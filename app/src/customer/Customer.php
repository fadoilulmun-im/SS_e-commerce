<?php
use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Member;
use SilverStripe\Assets\Image;

class Customer extends Member 
{
  private static $db = [
    'AccessToken' => 'Varchar',
    'Validation' => 'Varchar',
    'TokenResetPass' => 'Varchar'
  ];

  private static $has_one = [
    'PhotoProfile' => Image::class,
  ];

  private static $has_many = [
    'Orders' => Order::class,
    'Carts' => Cart::class
  ];

  public function toArray()
  {
    // return (array)$this;

    $arr = [
      'ID' => $this->ID,
      'name' => $this->FirstName,
      'email' => $this->Email,
      'photo' => $this->PhotoProfile->Link()
    ];

    return $arr;
  }

  public function validation() 
  {
    $result = [];

    $customer = Member::get()->filter([
      'ID:not' => $this->ID,
      'Email' => $this->Email
    ])->first();

    if($customer){
      $result[] = [
        'email' => 'This email is already registered'
      ];
    }

    if(!preg_match("/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$/i", $this->Email)){
      $result[] = [
        'email' => 'Email is invalid'
      ];
    }

    if(count($result) > 0){
      return $result;
    }
    
    return false;
  }

  private static $summary_fields = [
    'FirstName' => 'Name',
    'Email' => 'Email'
  ];

  public function getCMSFields() {
    $fields = parent::getCMSFields();
    $fields->removeByName("Surname");
    $fields->removeByName("FailedLoginCount");
    return $fields;
  }
}

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class CustomerAdmin extends ModelAdmin
{
  /**
   * Managed data objects for CMS
   * @var array
   */
  private static $managed_models = [
    'Customer'
  ];

  /**
   * URL Path for CMS
   * @var string
   */
  private static $url_segment = 'customers';

  /**
   * Menu title for Left and Main CMS
   * @var string
   */
  private static $menu_title = 'Customers';

  
}

?>