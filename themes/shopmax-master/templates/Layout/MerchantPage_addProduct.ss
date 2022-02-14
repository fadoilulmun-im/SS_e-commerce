
<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Add new product</h3>
    </div>
  </div>
</div>

<div class="site-section pt-4">
  <div class="container">
    <div class="row" id="content">
      <div class="col-md-6">
        <form id="formAdd" method="POST">
          <div class="form-group">
            <label for="title">Title</label>
            <input type="text" class="form-control" id="title" name="title" required>
          </div>
          <div class="form-group">
            <label for="price">price</label>
            <input type="number" class="form-control" id="price" name="price" required>
          </div>
          <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){
    $('#formAdd').submit(function(e){
      e.preventDefault();
      var spinner = $('#loader');

      const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
      spinner.show();
      $.post({
        url: 'product-api/store',
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        data:{
          title: $('#title').val(),
          price: $('#price').val()
        },
        success: async (res) =>{
          let response = JSON.parse(res);

          await Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
              toast.addEventListener('mouseenter', Swal.stopTimer)
              toast.addEventListener('mouseleave', Swal.resumeTimer)
            },
            icon: 'success',
            title: response.message
          })
          window.location.href = `merchant/editProduct/${response.data.ID}`;
        },
        error: (res) => {
          let responseJSON = JSON.parse(res.responseText);
          Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            icon: 'error',
            title: responseJSON.message
          });
        }
      }).always(function(res){
        spinner.hide();
      })
    });
  })
</script>