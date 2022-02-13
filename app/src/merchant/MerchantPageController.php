<?php

use SilverStripe\CMS\Controllers\ContentController;

  /**
   * Description
   * 
   * @package silverstripe
   * @subpackage mysite
   */
  class MerchantPageController extends PageController
  {
    public function doInit()
    {
      parent::doInit();
    }

    private static $allowed_actions = [
      'loginRegister',
      'order',
      'product'
    ];

    public function index()
    {
      return $this->customise([])->renderWith(['MerchantPage', 'PageMerchant']);
    }

    public function loginRegister()
    {
      return $this->customise([])->renderWith(['MerchantPage_loginRegister', 'PageMerchant']);
    }

    public function order()
    {
      return $this->customise([])->renderWith(['MerchantPage_order', 'PageMerchant']);
    }

    public function product()
    {
      return $this->customise([])->renderWith(['MerchantPage_product', 'PageMerchant']);
    }
  }
?>