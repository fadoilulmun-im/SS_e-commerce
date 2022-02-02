<?php

use SilverStripe\ORM\DataObject;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class OrderDetail extends DataObject
{
  private static $db = [
    'Quantity' => 'Int',
    'TotalPrice' => 'Currency'
  ];

  private static $has_one = [
    'Order' => Order::class,
    'Product' => Product::class
  ];

  public function toArray()
  {
    $arr = [
      'ID' => $this->ID,
      'Quantity' => $this->Quantity,
      'TotalPrice' => $this->TotalPrice,
      'Product' => $this->Product->toArray()
    ];

    return $arr;
  }

  private static $summary_fields = [
    'ID' => 'ID',
    'Order.ID' => 'Order ID',
    'TotalPrice' => 'Total'
  ];

}
?>