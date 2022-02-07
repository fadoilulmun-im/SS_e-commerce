<?php

use SilverStripe\CMS\Controllers\ContentController;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ShopPageController extends PageController
{
  public function doInit()
  {
    parent::doInit();
  }

  private static $allowed_actions = [
    'show'
  ];

  public function show()
  {
    return [];
  }
}
?>