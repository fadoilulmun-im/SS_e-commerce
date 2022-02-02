<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\ORM\DataObject;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class Order extends DataObject
{
  private static $db = [
    'TotalPrice' => 'Currency',
    'IsAccept' => "Enum(array('Accept', 'Reject'), null)"
  ];

  private static $has_many = [
    'OrderDetails' => OrderDetail::class,
  ];

  private static $has_one = [
    'Customer' => Customer::class
  ];

  public function toArray()
  {
    $arr = [
      'ID' => $this->ID,
      'TotalPrice' => $this->TotalPrice,
      'IsAccept' => $this->IsAccept
    ];

    return $arr;
  }

  public function toArrayOne()
  {
    $arr = [
      'ID' => $this->ID,
      'TotalPrice' => $this->TotalPrice,
      'DateOrder' => $this->DateOrder
    ];

    if(count($this->OrderDetails()) != 0){
      $arr['OrderDetails'] = [];
      foreach($this->OrderDetails() as $detail){
        $arr['OrderDetails'][] = $detail->toArray();
      }
    }else{
      $arr['OrderDetails'] = null;
    }

    return $arr;
  }

  private static $summary_fields = [
    'ID' => 'ID',
    'Customer.Title' => 'Customer',
    'TotalPrice' => 'Total',
    'IsAccept' => 'Is Accept ?'
  ];
}


/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class OrderAdmin extends ModelAdmin
{
  /**
   * Managed data objects for CMS
   * @var array
   */
  private static $managed_models = [
    'Order'
  ];

  /**
   * URL Path for CMS
   * @var string
   */
  private static $url_segment = 'Orders';

  /**
   * Menu title for Left and Main CMS
   * @var string
   */
  private static $menu_title = 'Orders';

  
}
?>