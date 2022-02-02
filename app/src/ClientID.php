<?php

use SilverStripe\ORM\DataObject;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ClientID extends DataObject
{
  private static $db = [
    'code' => 'Varchar'
  ];
}
?>