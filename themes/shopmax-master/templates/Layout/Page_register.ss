<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">Register</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row">
      <div class="col-6">
        <form id="formRegister" enctype="multipart/form-data">
          <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" class="form-control" id="name" name="name">
          </div>
          <div class="form-group">
            <label for="emailReg">Email address</label>
            <input type="email" class="form-control" id="emailReg" aria-describedby="emailHelp" name="email">
            <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
          </div>
          <div class="form-group">
            <label for="passwordReg">Password</label>
            <input type="password" class="form-control" id="passwordReg" name="password">
          </div>
          <div class="form-group">
            <label for="photo">Photo Profile</label>
            <input type="file" class="form-control" id="photo" name="photo">
          </div>
          <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  $("#formRegister").submit((e)=>{
    e.preventDefault();

    const name = $("#name").val();
    const email = $("#emailReg").val();
    const password = $("#passwordReg").val();
    const photo = $("#photo").val();

    var formData = new FormData();
    formData.append('name', name);
    formData.append('email', email);
    formData.append('password', password);
    formData.append('photo', photo);

    var settings = {
      "url": "customer-api/register",
      "method": "POST",
      "headers": {
        "ClientID": "61f0d060f1f163.13349246",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      "data": formData
    };

    $.ajax(settings).done(function (res) {
      console.log(res);
    });
  })
</script>