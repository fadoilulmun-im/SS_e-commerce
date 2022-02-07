<?php

namespace {

    use SilverStripe\CMS\Controllers\ContentController;
    use SilverStripe\ORM\DataObject;
    use SilverStripe\Control\HTTPRequest;
    use SilverStripe\Core\Injector\Injector;
    class PageController extends ContentController
    {
        /**
         * An array of actions that can be accessed via a request. Each array element should be an action name, and the
         * permissions or conditions required to allow the user to access it.
         *
         * <code>
         * [
         *     'action', // anyone can access this action
         *     'action' => true, // same as above
         *     'action' => 'ADMIN', // you must have ADMIN permissions to access this action
         *     'action' => '->checkAction' // you can only access this action if $this->checkAction() returns true
         * ];
         * </code>
         *
         * @var array
         */
        private static $allowed_actions = [
            'emailValidation',
            'resetPass',
            'login',
            'register',
            'registerSubmit'
        ];

        protected function init()
        {
            parent::init();
            // You can include any CSS or JS required by your project here.
            // See: https://docs.silverstripe.org/en/developer_guides/templates/requirements/
        }

        public function emailValidation()
        {
            $who = $this->request->param("ID");
            $code = $this->request->param("OtherID");
            // Customer::get()->filter('Validation', $code)->first();
            $customer = DataObject::get_one($who, "Validation='".$code."'");

            $Title = 'Verification';
            $Content = 'Verification '.$who.' Error, invalid code';
            if($customer){
                $customer->Validation = 'success';
                $customer->write();
                $Content = 'Verification '.$who.' Success';
            }

            return [
                'Content' => $Content, 
                'Title' => $Title
            ];
        }

        public function resetPass()
        {
            $who = $this->request->param("ID");
            $code = $this->request->param("OtherID");
            // Customer::get()->filter('Validation', $code)->first();
            $customer = DataObject::get_one($who, "TokenResetPass='".$code."'");

            $Title = 'Reset Password';
            $Content = '';
            $isValid = true;
            
            if(!$customer){
                $Title = 'Reset Password';
                $Content = 'Validation '.$who.' Error, invalid code';
                $isValid = false;
            }

            return [
                'Content' => $Content, 
                'Title' => $Title,
                'isValid' => $isValid
            ];
        }

        public function login()
        {
            # code...
        }

        public function register()
        {
            return [];
        }

        public function getTime()
        {
            return date("h:i:sa");
        }

    }
}
