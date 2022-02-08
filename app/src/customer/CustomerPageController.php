<?php

use SilverStripe\CMS\Controllers\ContentController;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class CustomerPageController extends PageController
{
  public  $id, $otherID;

  public function doInit()
  {
    parent::doInit();
    $this->id = $this->request->param('ID');
    $this->otherID = $this->request->param('OtherID');
  }

  private static $allowed_actions = [
    'order',
    'forgotPass',
    'resetPass'
  ];

  public function index()
  {
    return [];
  }

  public function order()
  {
    if($this->id){
      return $this->customise([])->renderWith(['OrderDetail', 'Page']);
    }
    return [];
  }

  public function forgotPass()
  {
    return [];
  }

  public function resetPass()
  {
    $code = $this->request->param("ID");

    $customer = Customer::get()->filter('TokenResetPass', $code)->first();

    $Title = 'Reset Password';
    $Content = '';
    $isValid = true;
    
    if(!$customer){
        $Title = 'Reset Password';
        $Content = 'Validation Error, invalid code';
        $isValid = false;
    }

    return [
        'Content' => $Content,
        'Title' => $Title,
        'isValid' => $isValid
    ];
  }
}
?>