<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\ORM\DataObject;

  /**
   * Description
   * 
   * @package silverstripe
   * @subpackage mysite
   */
  class Product extends DataObject
  {
    private static $db = [
      'Title' => 'Varchar',
      'Price' => 'Currency',
      'IsAvailable' => 'Boolean'
    ];

    private static $has_one = [
      'Merchant' => Merchant::class,
    ];

    private static $has_many = [
      'Images' => CustomImage::class,
    ];

    public function toArray()
    {
      // return (array)$this;

      $arr = [
        'ID' => $this->ID,
        'Title' => $this->Title,
        'Price' => $this->Price,
        'MerchantID' => $this->MerchantID,
        'IsAvailable' => $this->IsAvailable ? 'yes' : 'no'
      ];

      if(count($this->Images()) != 0){
        $arr['Images'] = [];
        foreach($this->Images() as $image){
          $arr['Images'][] = $image->toArray();
        }
      }else{
        $arr['Images'] = null;
      }

      return $arr;
    }

    private static $summary_fields = [
      'ID' => 'ID',
      'Title' => 'Title',
      'Price' => 'Price',
      'Merchant.FirstName' => 'Merchant',
      'IsAvailable' => 'Is Available ?'
    ];
  }


  /**
   * Description
   * 
   * @package silverstripe
   * @subpackage mysite
   */
  class ProductAdmin extends ModelAdmin
  {
    /**
     * Managed data objects for CMS
     * @var array
     */
    private static $managed_models = [
      'Product'
    ];
  
    /**
     * URL Path for CMS
     * @var string
     */
    private static $url_segment = 'products';
  
    /**
     * Menu title for Left and Main CMS
     * @var string
     */
    private static $menu_title = 'Products';
  
    
  }
?>