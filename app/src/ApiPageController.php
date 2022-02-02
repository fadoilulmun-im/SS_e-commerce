<?php

use SilverStripe\CMS\Controllers\ContentController;
use SilverStripe\ORM\DataObject;

/**
 * Description
 * 
 * @package silverstripe
 * @subpackage mysite
 */
class ApiPageController extends PageController
{
  public  $id, $otherID;
  
  public function doInit()
  {
    parent::doInit();
    if($this->checkClientID()){
      return $this->httpError(403, $this->checkClientID());
    }

    
    $this->id = $this->request->param('ID');
    $this->otherID = $this->request->param('OtherID');
  }

  public function checkClientID()
  {
    $headerClientID = isset($_SERVER['HTTP_CLIENTID']) ? $_SERVER['HTTP_CLIENTID'] : false;
    if(!$headerClientID){
      return json_encode([
        'status' => 'no',
        'message' => 'Api cant be accessed without clientid',
      ]);
    }
    $clientid = ClientID::get()->filter('code', $headerClientID)->First();
    if(!$clientid){
      return json_encode([
        'status' => 'no',
        'message' => 'ClientID Invalid',
      ]);
    }
  }

  public function checkAccessToken($who)
  {
    $headerAccessToken = isset($_SERVER['HTTP_ACCESSTOKEN']) ? $_SERVER['HTTP_ACCESSTOKEN'] : false;
    if(!$headerAccessToken){
      return [
        'status' => 'no',
        'message' => 'Api cant be accessed without access token',
      ];
    }
    $user = DataObject::get_one($who, "AccessToken='".$headerAccessToken."'");
    if(!$user){
      return [
        'status' => 'no',
        'message' => 'Access Token Invalid',
      ];
    }

    return [
      'status' => 'ok',
      'data' => $user
    ];
  }

  public function bodyEmailRegister($user)
  {
    $bodyEmail = '
      <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0;">
        <tbody>
          <tr>
            <td align="center" style="background-color:#eeeeee" bgcolor="#eeeeee" style="height: 100%">
              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tbody>
                  <tr>
                    <td align="center" valign="top" style="font-size:0;padding:35px" bgcolor="#044767">
                        
                      <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                          <tbody>
                            <tr>
                              <td align="center" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:36px;font-weight:800;line-height:48px">
                                <h1 style="font-size:36px;font-weight:800;margin:0;color:#ffffff">
                                  E-Commerce Ilul
                                </h1>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                        
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:35px 35px 20px 35px;background-color:#ffffff" bgcolor="#ffffff">
                        
                      <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                        <tbody>
                          <tr>
                            <td align="center" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:25px">
                              <h2 style="font-size:30px;font-weight:800;line-height:36px;color:#333333;margin:0">
                                Thank you for registering.
                              </h2>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:10px">
                              <p style="font-size:16px;font-weight:400;line-height:24px;color:#777777">
                                Please verify your email by clicking <a href="http://localhost/ct/ecommerce/home/emailValidation/'.$user->Classname.'/'.$user->Validation.'">here</a>.
                              </p>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                        
                    </td>
                  </tr>

                </tbody>
              </table>
                
            </td>
          </tr>
        </tbody>
      </table>
    ';

    return $bodyEmail;
  }

  public function bodyEmailForgot($user)
  {
    $bodyEmail = '
      <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0;">
        <tbody>
          <tr>
            <td align="center" style="background-color:#eeeeee" bgcolor="#eeeeee" style="height: 100%">
              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tbody>
                  <tr>
                    <td align="center" valign="top" style="font-size:0;padding:35px" bgcolor="#044767">
                        
                      <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                          <tbody>
                            <tr>
                              <td align="center" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:36px;font-weight:800;line-height:48px">
                                <h1 style="font-size:36px;font-weight:800;margin:0;color:#ffffff">
                                  E-Commerce Ilul
                                </h1>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                        
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:35px 35px 20px 35px;background-color:#ffffff" bgcolor="#ffffff">
                        
                      <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                        <tbody>
                          <tr>
                            <td align="center" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:25px">
                              <h2 style="font-size:30px;font-weight:800;line-height:36px;color:#333333;margin:0">
                                Reset Password.
                              </h2>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:10px">
                              <p style="font-size:16px;font-weight:400;line-height:24px;color:#777777">
                              Please reset your password by clicking <a href="http://localhost/ct/ecommerce/home/resetPass/'.$user->Classname.'/'.$user->TokenResetPass.'">here</a>.
                              </p>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                        
                    </td>
                  </tr>

                </tbody>
              </table>
                
            </td>
          </tr>
        </tbody>
      </table>
    ';

    return $bodyEmail;
  }

  public function bodyEmailOrder($order)
  {
    $arrOrderDetail = [];
    foreach($order->OrderDetails() as $detail){
      $arrOrderDetail[] = $detail->toArray();
    }
    // var_dump($arrOrderDetail[0]['Product']['Price']);die();
    $arrDetail = array_map(function($detail){
        return (
          '
          <tr>
            <td width="70%" align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding:15px 10px 5px 10px">
              '.$detail['Product']['Title'].' '.$detail['Quantity'].'X 
            </td>
            <td width="30%" align="right" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding:15px 10px 5px 10px">
              IDR '.number_format($detail['Product']['Price'], 0,',','.').'
            </td>
          </tr>
          '
        );
      }, $arrOrderDetail);
    // var_dump(implode('',$arrDetail));die();

    $bodyEmail = '
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
          <tr>
            <td align="center" style="background-color:#eeeeee" bgcolor="#eeeeee">
              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tbody>
                  <tr>
                    <td align="center" valign="top" style="font-size:0;padding:35px" bgcolor="#044767">
                        
                      <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                          <tbody>
                            <tr>
                              <td align="center" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:36px;font-weight:800;line-height:48px">
                                <h1 style="font-size:36px;font-weight:800;margin:0;color:#ffffff">
                                  E-Commerce Ilul
                                </h1>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                        
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:35px 35px 20px 35px;background-color:#ffffff" bgcolor="#ffffff">
                        
                      <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                        <tbody>
                          <tr>
                            <td align="center" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:25px">
                              <h2 style="font-size:30px;font-weight:800;line-height:36px;color:#333333;margin:0">
                                Thank you for ordering.
                              </h2>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:10px">
                              <p style="font-size:16px;font-weight:400;line-height:24px;color:#777777">
                                Please wait and check your order status <a href="http://localhost/ct/ecommerce/customer/order/">here</a>.
                              </p>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="padding-top:20px">
                              <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                  <tr>
                                    <td width="75%" align="left" bgcolor="#eeeeee" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px">
                                      Order ID
                                    </td>
                                    <td width="25%" align="right" bgcolor="#eeeeee" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px">
                                      #'.$order->ID.'
                                    </td>
                                  </tr>
                                  '.implode('',$arrDetail).'
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="padding-top:20px">
                              <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                  <tr>
                                    <td width="65%" align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px;border-top:3px solid #eeeeee;border-bottom:3px solid #eeeeee">
                                      TOTAL
                                    </td>
                                    <td width="35%" align="right" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px;border-top:3px solid #eeeeee;border-bottom:3px solid #eeeeee">
                                      IDR '.number_format($order->TotalPrice, 0,',','.').'
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          
                          <tr>
                            <td align="center" valign="top" style="font-size:0;padding-top:35px">
                              <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                                <table align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                                  <tbody>
                                    <tr>
                                      <td align="left" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:15px">
                                        <p style="font-size:15px;margin:0">
                                            The verification process takes a maximum of 24 hours
                                        </p>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                        
                    </td>
                  </tr>

                </tbody>
              </table>
                
            </td>
          </tr>
        </tbody>
      </table>
    ';

    return $bodyEmail;
  }

  public function bodyEmailOrderMerchant($order)
  {
    $arrOrderDetail = [];
    foreach($order->OrderDetails() as $detail){
      $arrOrderDetail[] = $detail->toArray();
    }

    $arrDetail = array_map(function($detail){
        return (
          '
          <tr>
            <td width="70%" align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding:15px 10px 5px 10px">
              '.$detail['Product']['Title'].' '.$detail['Quantity'].'X 
            </td>
            <td width="30%" align="right" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding:15px 10px 5px 10px">
              IDR '.number_format($detail['Product']['Price'], 0,',','.').'
            </td>
          </tr>
          '
        );
      }, $arrOrderDetail);
    // var_dump(implode('',$arrDetail));die();

    $bodyEmail = '
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tbody>
          <tr>
            <td align="center" style="background-color:#eeeeee" bgcolor="#eeeeee">
              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tbody>
                  <tr>
                    <td align="center" valign="top" style="font-size:0;padding:35px" bgcolor="#044767">
                        
                      <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                          <tbody>
                            <tr>
                              <td align="center" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:36px;font-weight:800;line-height:48px">
                                <h1 style="font-size:36px;font-weight:800;margin:0;color:#ffffff">
                                  E-Commerce Ilul
                                </h1>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                        
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:35px 35px 20px 35px;background-color:#ffffff" bgcolor="#ffffff">
                        
                      <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                        <tbody>
                          <tr>
                            <td align="center" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:25px">
                              <h2 style="font-size:30px;font-weight:800;line-height:36px;color:#333333;margin:0">
                                New Order For you.
                              </h2>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:10px">
                              <p style="font-size:16px;font-weight:400;line-height:24px;color:#777777">
                                Please check and accept or reject the order.
                              </p>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="padding-top:20px">
                              <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                  <tr>
                                    <td width="75%" align="left" bgcolor="#eeeeee" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px">
                                      Order ID
                                    </td>
                                    <td width="25%" align="right" bgcolor="#eeeeee" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px">
                                      #'.$order->ID.'
                                    </td>
                                  </tr>
                                  '.implode('',$arrDetail).'
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="padding-top:20px">
                              <table cellspacing="0" cellpadding="0" border="0" width="100%">
                                <tbody>
                                  <tr>
                                    <td width="65%" align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px;border-top:3px solid #eeeeee;border-bottom:3px solid #eeeeee">
                                      TOTAL
                                    </td>
                                    <td width="35%" align="right" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:800;line-height:24px;padding:10px;border-top:3px solid #eeeeee;border-bottom:3px solid #eeeeee">
                                      IDR '.number_format($order->TotalPrice, 0,',','.').'
                                    </td>
                                  </tr>
                                </tbody>
                              </table>
                            </td>
                          </tr>
                          
                          <tr>
                            <td align="center" valign="top" style="font-size:0;padding-top:35px">
                              <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                                <table align="left" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                                  <tbody>
                                    <tr>
                                      <td align="left" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:15px">
                                        <p style="font-size:15px;margin:0">
                                          The verification process should not take more than a maximum of 24 hours
                                        </p>
                                      </td>
                                    </tr>
                                  </tbody>
                                </table>
                              </div>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                        
                    </td>
                  </tr>

                </tbody>
              </table>
                
            </td>
          </tr>
        </tbody>
      </table>
    ';

    return $bodyEmail;
  }

  public function bodyEmailAcceptOrReject($order)
  {
    $bodyEmail = '
      <table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" style="position: absolute; top: 0; bottom: 0; left: 0; right: 0;">
        <tbody>
          <tr>
            <td align="center" style="background-color:#eeeeee" bgcolor="#eeeeee" style="height: 100%">
              <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tbody>
                  <tr>
                    <td align="center" valign="top" style="font-size:0;padding:35px" bgcolor="#044767">
                        
                      <div style="display:inline-block;max-width:100%;min-width:100px;vertical-align:top;width:100%">
                        <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:100%">
                          <tbody>
                            <tr>
                              <td align="center" valign="top" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:36px;font-weight:800;line-height:48px">
                                <h1 style="font-size:36px;font-weight:800;margin:0;color:#ffffff">
                                  E-Commerce Ilul
                                </h1>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </div>
                        
                    </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding:35px 35px 20px 35px;background-color:#ffffff" bgcolor="#ffffff">
                        
                      <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                        <tbody>
                          <tr>
                            <td align="center" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:25px">
                              <h2 style="font-size:30px;font-weight:800;line-height:36px;color:#333333;margin:0">
                                Your order has been '.$order->IsAccept.'ed.
                              </h2>
                            </td>
                          </tr>
                          <tr>
                            <td align="left" style="font-family:Open Sans,Helvetica,Arial,sans-serif;font-size:16px;font-weight:400;line-height:24px;padding-top:10px">
                              <p style="font-size:16px;font-weight:400;line-height:24px;color:#777777">
                                Your order with ID #'.$order->ID.' has been '.$order->IsAccept.'ed.
                              </p>
                            </td>
                          </tr>
                        </tbody>
                      </table>
                        
                    </td>
                  </tr>

                </tbody>
              </table>
                
            </td>
          </tr>
        </tbody>
      </table>
    ';

    return $bodyEmail;
  }
}
?>