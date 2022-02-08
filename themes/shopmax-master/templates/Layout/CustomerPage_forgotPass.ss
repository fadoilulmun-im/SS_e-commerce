<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">Forgot Password</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row">
      <div class="col-6">
        <form id="formForgot">
          <div class="form-group">
            <label for="emailForgot">Email address</label>
            <input type="email" class="form-control" id="emailForgot" aria-describedby="emailHelp" name="email">
            <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
          </div>
          <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){
    $('#formForgot').submit(function(e){
      e.preventDefault();
      const spinner = $('#loader');
      spinner.show();

      const email = $("#emailForgot").val();
      $.post({
        url: 'customer-api/forgotPassword',
        headers:{
          ClientID: "61f0d060f1f163.13349246",
        },
        data:{
          email: email
        },
        success: (res) => {
          const response = JSON.parse(res);
          alert(response.message);
        },
        error: (res) => {
          alert(JSON.parse(res.responseText).message);
        }
      }).always(function(){
        spinner.hide();
      })
    })
  })
</script>