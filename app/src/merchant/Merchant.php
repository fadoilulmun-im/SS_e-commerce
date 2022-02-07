<?php
use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Member;
use SilverStripe\Assets\Image;

class Merchant extends Member
{
  private static $db = [
    'AccessToken' => 'Varchar',
    'Validation' => 'Varchar',
    'TokenResetPass' => 'Varchar',
    'IsApproved' => 'Boolean',
    'IsOpen' => 'Boolean'
  ];

  private static $has_one = [
    'PhotoProfile' => Image::class,
    'Category' => MerchantCategory::class
  ];

  private static $has_many = [
    'Products' => Product::class,
    'Orders' => Order::class
  ];

  public function toArray()
  {

    $arr = [
      'ID' => $this->ID,
      'Name' => $this->FirstName,
      'Email' => $this->Email,
      'Photo' => $this->PhotoProfile->Link(),
      'Category' => $this->Category->Title,
      'IsOpen' => $this->IsOpen ? true : false
    ];

    return $arr;
  }

  public function toArrayOne()
  {

    $arr = [
      'ID' => $this->ID,
      'Name' => $this->FirstName,
      'Email' => $this->Email,
      'Photo' => $this->PhotoProfile->Link(),
      'Category' => $this->Category->Title,
      'IsOpen' => $this->IsOpen ? true : false
    ];

    if(count($this->Products()) != 0){
      $arr['Products'] = [];
      foreach($this->Products() as $product){
        $arr['Products'][] = $product->toArray();
      }
    }else{
      $arr['Products'] = null;
    }

    return $arr;
  }

  public function validation() 
  {
    $result = [];

    $merchant = Member::get()->filter([
      'ID:not' => $this->ID,
      'Email' => $this->Email
    ])->first();

    if($merchant){
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

  public function getCMSFields() {
    $fields = parent::getCMSFields();
    $fields->removeByName("Surname");
    $fields->removeByName("FailedLoginCount");
    $fields->removeByName("DirectGroups");
    return $fields;
  }
}

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class MerchantAdmin extends ModelAdmin
{
  /**
   * Managed data objects for CMS
   * @var array
   */
  private static $managed_models = [
    'Merchant'
  ];

  /**
   * URL Path for CMS
   * @var string
   */
  private static $url_segment = 'merchants';

  /**
   * Menu title for Left and Main CMS
   * @var string
   */
  private static $menu_title = 'Merchants';

  
}

?>