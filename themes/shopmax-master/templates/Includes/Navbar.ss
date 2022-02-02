<div class="site-navbar bg-white py-2">

  <div class="search-wrap">
    <div class="container">
      <a href="#" class="search-close js-search-close"><span class="icon-close2"></span></a>
      <form action="#" method="post">
        <input type="text" class="form-control" placeholder="Search keyword and hit enter...">
      </form>  
    </div>
  </div>

  <div class="container">
    <div class="d-flex align-items-center justify-content-between">
      <div class="logo">
        <div class="site-logo">
          <a href="home" class="js-logo-clone">E-Comm</a>
        </div>
      </div>
      <div class="main-nav d-none d-lg-block">
        <nav class="site-navigation text-right text-md-center" role="navigation">
          <ul class="site-menu js-clone-nav d-none d-lg-block">
            <% loop $Menu(1) %>
              <li <% if $LinkingMode == 'current' %>
                class="active"
              <% end_if %>><a href="$Link" title="$Title.XML">$MenuTitle.XML</a></li>
            <% end_loop %>
          </ul>
        </nav>
      </div>
      <div class="icons">
        <a href="#" class="icons-btn d-inline-block js-search-open"><span class="icon-search"></span></a>
        <a href="cart" class="icons-btn d-inline-block bag">
          <span class="icon-shopping-bag"></span>
          <span class="number">2</span>
        </a>
        <% if CurrentMember %>
          <a class="icons-btn d-inline-block" href='#' role="button" id="user" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="icon-user"></span>
          </a>

          <div class="dropdown-menu" aria-labelledby="user">
            <a class="dropdown-item" href="#">Profile</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item text-primary" href="#">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-left" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M6 12.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5v2a.5.5 0 0 1-1 0v-2A1.5 1.5 0 0 1 6.5 2h8A1.5 1.5 0 0 1 16 3.5v9a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 5 12.5v-2a.5.5 0 0 1 1 0v2z"/>
                <path fill-rule="evenodd" d="M.146 8.354a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L1.707 7.5H10.5a.5.5 0 0 1 0 1H1.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3z"/>
              </svg>
              <span class="ml-2">Sign Out</span>
            </a>
          </div>
        <% else %>
          <button class="btn btn-light text-primary ml-2"  type="button" id="login" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Login
          </button>

          <div class="dropdown-menu" aria-labelledby="login">
            <form class="px-4 py-3" id="formLogin">
              <div class="form-group">
                <label for="email">Email address</label>
                <input type="email" class="form-control" id="email" placeholder="email@example.com" name="email">
              </div>
              <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" placeholder="Password" name="password">
              </div>
              <button type="submit" class="btn btn-primary btn-block">Sign in</button>
            </form>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item" href="home/register">New around here? Sign up</a>
            <a class="dropdown-item" href="#">Forgot password?</a>
          </div>
        <% end_if %>
        
        <a href="#" class="site-menu-toggle js-menu-toggle ml-3 d-inline-block d-lg-none"><span class="icon-menu"></span></a>
      </div>
    </div>
  </div>
</div>

<script>
  $("#formLogin").submit(function(e){
    e.preventDefault();
    var settings = {
      "url": "customer-api/login",
      "method": "POST",
      "headers": {
        "ClientID": "61f0d060f1f163.13349246",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      "data": {
        "email": $("#email").val(),
        "password": $("#password").val()
      }
    };

    $.ajax(settings).done(function (res) {
      console.log(res);
    });
  })
  
</script>