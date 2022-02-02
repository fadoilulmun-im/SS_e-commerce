<?php

use SilverStripe\CMS\Controllers\ContentController;
use SilverStripe\CMS\Model\SiteTree;

use SilverStripe\Assets\Upload;
use SilverStripe\Assets\Image;
use SilverStripe\Security\MemberAuthenticator\MemberAuthenticator;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Control\Email\Email;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class MerchantApiPage extends Page
{
  
}

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class MerchantApiPageController extends ApiPageController
{
  public $merchant, $checkToken, $id, $otherID;

  private static $allowed_actions = [
    'register',
    'emailValidation',
    'login',
    'logout',
    'update',
    'changePhotoProfile',
    'isOpen',
    'show',
    'acceptOrRejectOrder',
    'rejectOrder',
    'forgotPassword',
    'resetPassword',
    'listOrders'
  ];

  public function doInit()
  {
    parent::doInit();
    $this->checkToken = $this->checkAccessToken('Merchant');
    if($this->checkToken['status'] == 'ok'){
      $this->merchant = $this->checkToken['data'];
    }

    $this->id = $this->request->param('ID');
    $this->otherID = $this->request->param('OtherID');
  }

  public function register()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $merchant = Merchant::create();
    $merchant->FirstName = $_REQUEST['name'];
    $merchant->Email = $_REQUEST['email'];
    $merchant->CategoryID = $_REQUEST['CategoryID'];
    $merchant->Password = $_REQUEST['password'];
    $merchant->Validation = uniqid('', true);
    $merchant->Locale = 'id_ID';

    $upload = new Upload();
    $photo = new Image();
    $upload->loadIntoFile($_FILES['photo'], $photo, 'merchant-photo');
    $merchant->PhotoProfileID = $photo->ID;

    if($merchant->validation()){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Can\'t register',
        'data' => $merchant->validation()
      ]), 400);
    }

    $merchant->write();

    $email = new Email('no-reply@mydomain.com', $merchant->Email, 'Registration success', $this->bodyEmailRegister($merchant));
    if(!$email->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email, Please double check your email address is it correct"
      ]);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Registration successful, please check your email',
      'data' => $merchant->toArray()
    ]);
  }

  public function emailValidation()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }
    
    $code = $this->request->param("ID");
    $merchant = Merchant::get()->filter('Validation', $code)->first();
    if($merchant){
      $merchant->Validation = 'success';
      $merchant->write();
      return json_encode([
        'status' => 'ok',
        'message' => 'Verification Success',
        'data' => $merchant->toArray()
      ]);
    }

    return json_encode([
      'status' => 'no',
      'message' => 'Verification Error'
    ]);
  }

  public function login()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $merchant = Merchant::get()->filter('Email', $_REQUEST['email'])->first();
    if(!$merchant){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Invalid Credentials'
      ]), 403);
    }

    if($merchant->Validation != 'success'){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Account has not been validated, please check email'
      ]), 403);
    }

    if(!$merchant->IsApproved){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Account is still in the approval process'
      ]), 403);
    }

    $auth = new MemberAuthenticator();
    $result = $auth->checkPassword($merchant, $_REQUEST['password']);
    if(!$result->isValid()){
      return json_encode([
        'status' => 'no',
        'message' => 'Invalid Credentials'
      ]);
    }

    $merchant->AccessToken = uniqid('', true);
    $merchant->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Login Success',
      'data' => $merchant->toArray(),
      'AccessToken' => $merchant->AccessToken
    ]);
  }

  public function logout()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $this->merchant->AccessToken = null;
    $this->merchant->write();
    return json_encode([
      'status' => 'ok',
      'message' => 'Logout Success'
    ]);
  }

  public function update()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $this->merchant->FirstName = $_REQUEST['name'];
    $this->merchant->Email = $_REQUEST['email'];
    if(isset($_REQUEST['password']) && $_REQUEST['password'] != ''){
      $this->merchant->Password = $_REQUEST['password'];
    }

    $this->merchant->write();
    return json_encode([
      'status' => 'ok',
      'message' => 'Update Success',
      'data' => $this->merchant->toArray()
    ]);
  }

  public function changePhotoProfile()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $upload = new Upload();
    $photo = new Image();
    $upload->loadIntoFile($_FILES['photo'], $photo, 'merchant-photo');
    $this->merchant->PhotoProfileID = $photo->ID;
    $this->merchant->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Change photo profile success',
      'data' => $this->merchant->toArray()
    ]);
  }

  public function forgotPassword()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $merchant = Merchant::get()->filter('Email', $_REQUEST['email'])->first();

    if(!$merchant){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Merchant not found'
      ]), 404);
    }

    $merchant->TokenResetPass = uniqid('', true);
    $merchant->write();

    $email = new Email('no-reply@mydomain.com', $merchant->Email, 'Forgot Password', $this->bodyEmailForgot($merchant));
    if(!$email->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email, Please double check your email address is it correct"
      ]);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Please check your email'
    ]);
  }

  public function resetPassword()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $merchant = Merchant::get()->filter('TokenResetPass', $this->id)->first();
    $merchant->Password = $_REQUEST['password'];
    $merchant->TokenResetPass = null;
    $merchant->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Reset password success, please login with your new password'
    ]);
  }

  public function isOpen()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $isOpen = $this->id == 'true' ? true : false;
    $this->merchant->IsOpen = $isOpen;
    $this->merchant->write();

    $status = $isOpen ? 'Open' : 'Closed';
    return json_encode([
      'status' => 'ok',
      'message' => "Merchant is $status"
    ]);
  }

  public function show()
  {
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $merchant = $this->merchant;

    if(!$merchant){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'merchant not found'
      ]), 404);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully get one merchant',
      'data' => $merchant->toArrayOne()
    ]);
  }

  public function acceptOrRejectOrder()
  {
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $order = Order::get()->byID($this->id);
    
    if(!$order){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Order not found'
      ]), 404);
    }

    $order->IsAccept = $this->otherID == 'Accept' ? 'Accept' : 'Reject';
    $emailToCustomer = new Email('no-reply@mydomain.com', $order->Customer->Email, 'Order '.$order->IsAccept.'ed', $this->bodyEmailAcceptOrReject($order));
    if(!$emailToCustomer->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email, Please double check in the email address is it correct"
      ]);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully '.$order->IsAccept.' the order',
      'data' => $order->toArray()
    ]);
  }

  public function listOrders()
  {
    if($this->checkToken['status'] == 'no'){
      return json_encode($this->checkToken);
    }

    $orders = Order::get()->filter([
      'OrderDetails.Product.MerchantID' => $this->merchant->ID
    ]);

    $arrOrders = [];
    foreach($orders as $order){
      $arrOrders[] = $order->toArray();
    }
    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully get all orders',
      'data' => $arrOrders
    ]);
  }
}

?>