<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\ORM\DataObject;

  /**
   * Description
   * 
   * @package silverstripe
   * @subpackage mysite
   */
  class MerchantCategory extends DataObject
  {
    private static $db = [
      'Title' => 'Varchar'
    ];

    private static $has_many = [
      'Merchants' => Merchant::class,
    ];
  }

  /**
   * Description
   * 
   * @package silverstripe
   * @subpackage mysite
   */
  class MerchantCategoryAdmin extends ModelAdmin
  {
    /**
     * Managed data objects for CMS
     * @var array
     */
    private static $managed_models = [
      'MerchantCategory'
    ];
  
    /**
     * URL Path for CMS
     * @var string
     */
    private static $url_segment = 'merchant-category';
  
    /**
     * Menu title for Left and Main CMS
     * @var string
     */
    private static $menu_title = 'Merchant Category';
  
    
  }
?>