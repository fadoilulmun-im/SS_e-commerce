
<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Edit product</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row" id="content">
      
    </div>
  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();

    let id = (window.location.pathname).split('/');
    id = id[id.length -1];
    let product = [];
    let images = [];

    const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
    await $.get({
      url: `product-api/show/${id}`,
      headers: {
        ClientID: "61f0d060f1f163.13349246",
        AccessToken : AccessToken
      },
      success: async (res) =>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        product = responseJSON.data;
        images = product.Images

        $('#content').html(`
          <div class="col-md-6">
            <form id="formEdit" enctype="multipart/form-data">
              <div class="form-group">
                <label for="title">Title</label>
                <input type="text" class="form-control" id="title" name="title" value="${product.Title}">
              </div>
              <div class="form-group">
                <label for="price">price</label>
                <input type="number" class="form-control" id="price" name="price" value="${product.Price}">
              </div>
              <button type="submit" class="btn btn-primary btn-block">Update</button>
            </form>
          </div>
          <div class="col-md-6">
            <label for="image">Add Image</label>
            <input type="file" class="form-control" id="image" name="image">
            <br>
            <ul id="sortable">
              ${images ? images.map((item,index)=>{
                return (`
                  <li class="p-2 border">
                    <img src="${item.Link}" width="250px" alt="" srcset="">
                    <a href="#" class="btn-sm btn-danger float-right delete-img" data-id="${item.ID}">
                      <i class="bi bi-trash-fill"></i>
                    </a>
                  </li>
                `)
              }).join('') : 'No pictures yet'}
            </ul>
          </div>
        `)
      },
      error: async (res) => {
        let responseJSON = JSON.parse(res.responseText);
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
          icon: 'error',
          title: responseJSON.message
        });

        window.history.back();
      }
    }).always(function(res){
      spinner.hide();
    })

    $('#image').change(async function(e){
      e.preventDefault();
      spinner.show();
      const photo = $("#image")[0].files;
      const formData = new FormData();
      formData.append("images", photo[0]);

      await $.post({
        url: `product-api/addImage/${id}`,
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        data: formData,
        success: (res) =>{
          let response = JSON.parse(res);

          Swal.fire({
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

          images = response.data.Images;
          $('#sortable').html(`
            ${images.map((item,index)=>{
              return (`
                <li class="p-2 border">
                  <img src="${item.Link}" width="250px" alt="" srcset="">
                  <a href="" class="btn-sm btn-danger float-right delete-img" data-id="${item.ID}">
                    <i class="bi bi-trash-fill"></i>
                  </a>
                </li>
              `)
            }).join('')}
          `)
        },
        error: async (res) => {
          let responseJSON = JSON.parse(res.responseText);
          await Swal.fire({
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
    })

    $('#formEdit').submit(function(e){
      e.preventDefault();
      spinner.show();

      $.post({
        url: `product-api/update/${id}`,
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        data:{
          title: $('#title').val(),
          price: $('#price').val()
        },
        success: (res) => {
          let response = JSON.parse(res);

          Swal.fire({
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

          $('#title').val(response.data.Title);
          $('#price').val(response.data.Price);
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
        console.log(res)
      })
    })

    $('.delete-img').click(function(e){
      e.preventDefault();

      let idImg = $(this).data('id');
      
      Swal.fire({
        title: `Are you sure to delete this image ?`,
        showCancelButton: true,
      }).then((result)=>{
        if (result.isConfirmed){
          spinner.show();
          $.post({
            url: `product-api/destroyImage/${id}/${idImg}`,
            headers: {
              ClientID: "61f0d060f1f163.13349246",
              AccessToken : AccessToken
            },
            success: (res) => {
              let response = JSON.parse(res);

              Swal.fire({
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
              });

              $(this).parent().hide();
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
        }
      })
    })

    $('#sortable').sortable();

  })
</script>