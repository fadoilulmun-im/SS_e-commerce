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
	<%-- <% require themedCSS('aos') %>
	<% require themedCSS('bootstrap.min') %>
	<% require themedCSS('jquery-ui') %>
	<% require themedCSS('magnific-popup') %>
	<% require themedCSS('owl.carousel.min') %>
	<% require themedCSS('owl.theme.default.min') %>
	<% require themedCSS('style') %> --%>

  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Mukta:300,400,700"> 
  <link rel="stylesheet" href="$ThemeDir/fonts/icomoon/style.css">


  <link rel="stylesheet" href="$ThemeDir/css/aos.css">
  <link rel="stylesheet" href="$ThemeDir/css/bootstrap.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/bootstrap.min.css.map">
  <link rel="stylesheet" href="$ThemeDir/css/jquery-ui.css">
  <link rel="stylesheet" href="$ThemeDir/css/magnific-popup.css">
  <link rel="stylesheet" href="$ThemeDir/css/owl.carousel.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/owl.theme.default.min.css">
  <link rel="stylesheet" href="$ThemeDir/css/style.css?$ContentLocale">
<script src="$ThemeDir/js/jquery-3.3.1.min.js"></script>

  <%-- <link rel="shortcut icon" href="themes/simple/images/favicon.ico" /> --%>
</head>
<body>
  <div class="site-wrap">
    <% include Navbar %>
    
    $Layout

    <% include Footer %>
  </div>
  
<%-- <% require javascript('//code.jquery.com/jquery-3.3.1.min.js') %> --%>
<%-- <% require themedJavascript('aos') %>
<% require themedJavascript('bootstrap.min') %>
<% require themedJavascript('jquery-3.3.1.min') %>
<% require themedJavascript('jquery-ui.js') %>
<% require themedJavascript('jquery.magnific-popup.min') %>
<% require themedJavascript('main') %>
<% require themedJavascript('owl.carousel.min') %>
<% require themedJavascript('popper.min') %>
<% require themedJavascript('slick.min') %> --%>

<script src="$ThemeDir/js/jquery-ui.js"></script>
<script src="$ThemeDir/js/popper.min.js"></script>
<script src="$ThemeDir/js/bootstrap.min.js"></script>
<script src="$ThemeDir/js/owl.carousel.min.js"></script>
<script src="$ThemeDir/js/jquery.magnific-popup.min.js"></script>
<script src="$ThemeDir/js/aos.js"></script>

<script src="$ThemeDir/js/main.js"></script>
<script src="$ThemeDir/js/slick.min.js"></script>
</body>
</html>
