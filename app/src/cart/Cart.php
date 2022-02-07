<?php

use SilverStripe\ORM\DataObject;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class Cart extends DataObject
{
  private static $db = [
    'Quantity' => 'Int',
    'TotalPrice' => 'Currency'
  ];

  private static $has_one = [
    'Product' => Product::class,
    'Customer' => Customer::class
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
}
?>