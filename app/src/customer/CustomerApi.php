<?php
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
class CustomerApiPage extends Page
{
}


/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class CustomerApiPageController extends ApiPageController
{
  public $customer, $checkToken;

  private static $allowed_actions = [
    'register',
    'emailValidation',
    'login',
    'logout',
    'update',
    'changePhotoProfile',
    'search',
    'merchant',
    'addToCart',
    'deleteFromCart',
    'updateInCart',
    'checkout',
    'listCart',
    'listOrder',
    'tesemail',
    'forgotPassword'
  ];

  public function tesemail()
  {
    $customer = Customer::get()->filter('Email', 'asd@asd.asd')->first();
    $email = new Email('no-reply@mydomain.com', $customer->Email, 'My test subject', $this->bodyEmailRegister($customer));
    if($email->send()){
      return json_encode([
        'status' => 'asjdkhk'
      ]);
    }
  }

  public function doInit()
  {
    parent::doInit();
    $this->checkToken = $this->checkAccessToken('Customer');
    if($this->checkToken['status'] == 'ok'){
      $this->customer = $this->checkToken['data'];
    }
  }

  public function register()
  {
    $customer = Customer::create();
    $customer->FirstName = $_REQUEST['name'];
    $customer->Email = $_REQUEST['email'];
    $customer->Password = $_REQUEST['password'];
    $customer->Validation = uniqid('', true);
    $customer->Locale = 'id_ID';

    $upload = new Upload();
    $photo = new Image();
    $upload->loadIntoFile($_FILES['photo'], $photo, 'customer-photo');
    $customer->PhotoProfileID = $photo->ID;

    if($customer->validation()){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Can\'t register',
        'data' => $customer->validation()
      ]), 400);
    }

    $customer->write();

    $email = new Email('no-reply@mydomain.com', $customer->Email, 'Registration success', $this->bodyEmailRegister($customer));
    if(!$email->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email, Please double check your email address is it correct"
      ]);
    }
    return json_encode([
      'status' => 'ok',
      'message' => 'Registration successful, please check your email',
      'data' => $customer->toArray()
    ]);
  }

  public function emailValidation()
  {
    
    $code = $this->request->param("ID");
    $customer = Customer::get()->filter('Validation', $code)->first();
    if($customer){
      $customer->Validation = 'success';
      $customer->write();
      return json_encode([
        'status' => 'ok',
        'message' => 'Verification Success',
        'data' => $customer->toArray()
      ]);
    }

    return json_encode([
      'status' => 'no',
      'message' => 'Verification Error'
    ]);
  }

  public function login()
  {

    $customer = Customer::get()->filter('Email', $_REQUEST['email'])->first();
    if(!$customer){
      return json_encode([
        'status' => 'no',
        'message' => 'Invalid Credentials'
      ]);
    }

    if($customer->Validation != 'success'){
      return json_encode([
        'status' => 'no',
        'message' => 'Account not verified'
      ]);
    }

    $auth = new MemberAuthenticator();
    $result = $auth->checkPassword($customer, $_REQUEST['password']);
    if(!$result->isValid()){
      return json_encode([
        'status' => 'no',
        'message' => 'Invalid Credentials'
      ]);
    }

    $customer->AccessToken = uniqid('', true);
    $customer->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Login Success',
      'data' => $customer->toArray(),
      'AccessToken' => $customer->AccessToken
    ]);
  }

  public function logout()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $this->customer->AccessToken = null;
    $this->customer->write();
    return json_encode([
      'status' => 'ok',
      'message' => 'Logout Success'
    ]);
  }

  public function update()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $this->customer->FirstName = $_REQUEST['name'];
    $this->customer->Email = $_REQUEST['email'];
    if(isset($_REQUEST['password']) && $_REQUEST['password'] != ''){
      $this->customer->Password = $_REQUEST['password'];
    }

    $this->customer->write();
    return json_encode([
      'status' => 'ok',
      'message' => 'Update Success',
      'data' => $this->customer->toArray()
    ]);
  }

  public function changePhotoProfile()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $upload = new Upload();
    $photo = new Image();
    $upload->loadIntoFile($_FILES['photo'], $photo, 'customer-photo');
    $this->customer->PhotoProfileID = $photo->ID;
    $this->customer->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Change photo profile success',
      'data' => $this->customer->toArray()
    ]);
  }

  public function forgotPassword()
  {
    if($this->checkClientID()){
      return $this->checkClientID();
    }

    $customer = Customer::get()->filter('Email', $_REQUEST['email'])->first();

    if(!$customer){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Customer not found'
      ]), 404);
    }

    $customer->TokenResetPass = uniqid('', true);
    $customer->write();

    $email = new Email('no-reply@mydomain.com', $customer->Email, 'Forgot Password', $this->bodyEmailForgot($customer));
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

    $customer = Customer::get()->filter('TokenResetPass', $this->id)->first();
    $customer->password = $_REQUEST['password'];
    $customer->TokenResetPass = null;
    $customer->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Reset password success, please login with your new password'
    ]);
  }

  public function search()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $search = $this->request->param('ID');

    $merchants = Merchant::get()->filter([
      'FirstName:PartialMatch:nocase' => $search,
      'Validation' => 'success'
    ]);
    $arrMerchants = [];
    foreach($merchants as $merchant){
      $arrMerchants[] = $merchant->toArray();
    }

    $products = Product::get()->filter('Title:PartialMatch:nocase', $search);
    $arrproducts = [];
    foreach($products as $product){
      $arrproducts[] = $product->toArray();
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Search success',
      'data' => [
        'Merchants' => $arrMerchants,
        'Products' => $arrproducts
      ]
    ]);
  }

  public function merchant()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $merchant = Merchant::get()->byID($this->id);
    if(!$merchant){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Merchant not found'
      ]), 404);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Success get detail merchant',
      'data' => $merchant->toArrayOne()
    ]);
  }

  public function addToCart()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $product = Product::get()->byID($this->id);

    if(!$product){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found'
      ]), 404);
    }

    if(!$product->IsAvailable){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not Available'
      ]), 400);
    }

    if(!$product->Merchant->IsOpen){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Merchant is closed'
      ]), 400);
    }
    
    // $order = Order::get()->filter([
    //   'DateOrder' => null,
    //   'CustomerID' => $this->customer->ID
    // ])->first();

    $check = Cart::get()->filter([
      'Customer.ID' => $this->customer->ID,
      'ProductID' => $this->id
    ])->first();

    if($check){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'This product is already in the cart',
        'data' => $check->toArray()
      ]), 409);
    }

    // if(!$order){
    //   $order = Order::create();
    //   $order->CustomerID = $this->customer->ID;
    //   $order->write();
    // }

    $cart = Cart::create();
    $cart->ProductID = $product->ID;
    $cart->Quantity = $_REQUEST['quantity'];
    $cart->CustomerID = $this->customer->ID;
    $cart->TotalPrice = $product->Price * $_REQUEST['quantity'];
    $cart->write();

    return new HTTPResponse(json_encode([
      'status' => 'yes',
      'message' => 'Success add product to cart',
      'data' => $cart->toArray()
    ]), 201);
  }

  public function deleteFromCart()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $cart = Cart::get()->filter([
      'ProductID' => $this->id,
      'CustomerID' => $this->customer->ID
    ])->first();

    if(!$cart){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found in cart'
      ]), 404);
    }

    $cart->delete();
    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully delete product in cart',
      'data' => $cart->toArray()
    ]);

  }

  public function updateInCart()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $cart = Cart::get()->filter([
      'ProductID' => $this->id,
      'CustomerID' => $this->customer->ID
    ])->first();

    if(!$cart){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'Product not found in cart'
      ]), 404);
    }

    $cart->Quantity = $_REQUEST['quantity'];
    $cart->TotalPrice = $cart->Product->Price * $_REQUEST['quantity'];
    $cart->write();

    return json_encode([
      'status' => 'ok',
      'message' => 'Successfully update cart',
      'data' => $cart->toArray()
    ]);
  }

  public function checkout()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $carts = Cart::get()->filter([
      // 'ID' => $this->id,
      'CustomerID' => $this->customer->ID
    ]);

    if(count($carts) <= 0){
      return new HTTPResponse(json_encode([
        'status' => 'no',
        'message' => 'cart not found'
      ]), 404);
    }

    // var_dump( (array) $order->OrderDetails()[0]);die();
    // $emailToMerchant = new Email('no-reply@mydomain.com', $order->OrderDetails()[0]->Product->Merchant->Email, 'New Order', $this->bodyEmailOrder($order));


    // $order->DateOrder = date("Y-m-d H:i:s");
    $order = Order::create();
    $order->CustomerID = $this->customer->ID;
    $order->MerchantID = $carts[0]->Product->Merchant->ID;
    $order->write();
    $totalPrice = 0;
    foreach($carts as $detail){
      $orderDetail = OrderDetail::create();
      $orderDetail->ProductID = $detail->ProductID;
      $orderDetail->Quantity = $detail->Quantity;
      $orderDetail->TotalPrice = $detail->TotalPrice;
      $orderDetail->OrderID = $order->ID;
      $orderDetail->write();
      $totalPrice += $detail->TotalPrice;
      $detail->delete();
    }

    $order->TotalPrice = $totalPrice;
    $order->write();

    $emailToCustomer = new Email('no-reply@mydomain.com', $order->Customer->Email, 'New Order', $this->bodyEmailOrder($order));
    if(!$emailToCustomer->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email, Please double check your email address is it correct"
      ]);
    }

    $emailToMerchant = new Email('no-reply@mydomain.com', $order->OrderDetails()[0]->Product->Merchant->Email, 'New Order', $this->bodyEmailOrderMerchant($order));
    if(!$emailToMerchant->send()){
      return json_encode([
        'status' => 'no',
        'message' => "Can't send email to merchant"
      ]);
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Success checkout order',
      'data' => $order->toArrayOne()
    ]);
  }

  public function listCart()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $carts = Cart::get()->filter([
      'Customer.ID' => $this->customer->ID
    ]);
    $arrCart = [];
    foreach($carts as $cart){
      $arrCart[] = $cart->toArray();
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Success get all product in cart',
      'data' => $arrCart
    ]);
  }

  public function listOrder()
  {
    if($this->checkToken['status'] == 'no'){
      return $this->httpError(403,json_encode($this->checkToken));
    }

    $orders = Order::get()->filter([
      'CustomerID' => $this->customer->ID,
      'DateOrder:not' => null
    ]);

    $arrOrders = [];
    foreach($orders as $order){
      $arrOrders[] = $order->toArray();
    }

    return json_encode([
      'status' => 'ok',
      'message' => 'Success get all orders',
      'data' => $arrOrders
    ]);
  }
}

?>