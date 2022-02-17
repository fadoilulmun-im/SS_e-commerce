<!DOCTYPE html>
<!--
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Simple. by Sara (saratusar.com, @saratusar) for Innovatif - an awesome Slovenia-based digital agency (innovatif.com/en)
Change it, enhance it and most importantly enjoy it!
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-->

<!--[if !IE]><!-->
<html lang="$ContentLocale">
<!--<![endif]-->
<!--[if IE 6 ]><html lang="$ContentLocale" class="ie ie6"><![endif]-->
<!--[if IE 7 ]><html lang="$ContentLocale" class="ie ie7"><![endif]-->
<!--[if IE 8 ]><html lang="$ContentLocale" class="ie ie8"><![endif]-->
<head>
	<% base_tag %>
	<title><% if $MetaTitle %>$MetaTitle<% else %>$Title<% end_if %> &raquo; $SiteConfig.Title</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	$MetaTags(false)
	<!--[if lt IE 9]>
	<script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->

  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mukta:300,400,700"> 
  <link rel="stylesheet" href="$ThemeDir/fonts/icomoon/style.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">

  <link rel="stylesheet" href="$ThemeDir/css/aos.css">
  <link rel="stylesheet" href="$ThemeDir/css/bootstrap.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/bootstrap.min.css.map">
  <link rel="stylesheet" href="$ThemeDir/css/jquery-ui.css">
  <link rel="stylesheet" href="$ThemeDir/css/magnific-popup.css">
  <link rel="stylesheet" href="$ThemeDir/css/owl.carousel.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/owl.theme.default.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/style.css?$ContentLocale">
  <script src="$ThemeDir/js/jquery-3.3.1.min.js"></script>
  <script src="//cdn.jsdelivr.net/npm/sweetalert2@11"></script>

  <style>
    #loader {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      width: 100%;
      background: rgba(0,0,0,0.75) url($ThemeDir/images/loading-bubbles.gif) no-repeat center center;
      z-index: 10000;
    }
    .swal2-container {
      z-index: 9999999;
    }
  </style>
</head>
<body>
  <div class="site-wrap">
    <% include Navbar %>
    
    $Layout

    <% include Footer %>
  </div>
  <div id="loader"></div>

<script src="$ThemeDir/js/jquery-ui.js"></script>
<script src="$ThemeDir/js/popper.min.js"></script>
<script src="$ThemeDir/js/bootstrap.min.js"></script>
<script src="$ThemeDir/js/owl.carousel.min.js"></script>
<script src="$ThemeDir/js/jquery.magnific-popup.min.js"></script>
<script src="$ThemeDir/js/aos.js"></script>

<script src="$ThemeDir/js/main.js?$ContentLocale"></script>
<script src="$ThemeDir/js/slick.min.js"></script>
</body>
</html>
