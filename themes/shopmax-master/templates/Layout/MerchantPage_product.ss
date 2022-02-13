
<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Products</h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row mb-5">
      <div class="col-12">
        <table class="table table-stripped text-dark" id="data-table" style="width:100%">
          <thead>
            <tr>
              <th >Image</th>
              <th >Title</th>
              <th >Price</th>
              <th >Available</th>
              <th >Action</th>
            </tr>
          </thead>
          <tbody id="lists-product">
            
          </tbody>
        </table>
      </div>
      
    </div>

  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();

    const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
    
    await $.get({
      url: 'product-api/merchant',
      headers: {
        ClientID: "61f0d060f1f163.13349246",
        AccessToken : AccessToken
      },
      success: async(res)=>{

        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        let data = await responseJSON.data;

        data.forEach((item, index)=>{
          $('#lists-product').append(`
            <tr>
              <td>
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#modal-image-${item.ID}">
                  <img src="${item.Images ? item.Images[0].Link : ''}" alt="Image" class="img-fluid" width="100px">
                </button>
              </td>
              <td>
                ${item.Title}
              </td>
              <td id="price-${item.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.Price)}</td>
              <td>
                <div class="radio">
                  <input label="Yes" type="radio" name="available-${item.ID}" value="yes" ${item.IsAvailable == 'yes' ? 'checked' : ''}>
                  <input label="No" type="radio" name="available-${item.ID}" value="no" ${item.IsAvailable == 'no' ? 'checked' : ''}>
                </div>
              </td>
              <td>
                <a class="btn-sm btn-info text-white">Show</a>
                <a class="btn-sm btn-warning text-white">Edit</a>
                <a class="btn-sm btn-danger text-white">Delete</a>
              </td>
            </tr>
          `)

          $(`input[name=available-${item.ID}]`).change(function(e){
            e.preventDefault();
            spinner.show();
            let val = $(this).val() == 'yes' ? 'true' : 'false' ;
            $.post({
              url: `product-api/isAvail/${item.ID}/${val}`,
              headers: {
                ClientID: "61f0d060f1f163.13349246",
                AccessToken : AccessToken
              },
              success: async (res) => {
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
            }).always(function(){
              spinner.hide();
            })
          });

          $('#modal').append(`
          <!-- Modal -->
            <div class="modal fade" id="modal-image-${item.ID}" aria-labelledby="ModalLabel-${item.ID}" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="ModalLabel-${item.ID}">${item.Title}</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div id="carouselIndicators-${item.ID}" class="carousel slide" data-ride="carousel">
                      <ol class="carousel-indicators">
                        ${item.Images.map}
                        <li data-target="#carouselIndicators-${item.ID}" data-slide-to="0" class="active"></li>
                        <li data-target="#carouselIndicators-${item.ID}" data-slide-to="1"></li>
                        <li data-target="#carouselIndicators-${item.ID}" data-slide-to="2"></li>
                      </ol>
                      <div class="carousel-inner">
                        <div class="carousel-item active">
                          <img src="..." class="d-block w-100" alt="...">
                        </div>
                        <div class="carousel-item">
                          <img src="..." class="d-block w-100" alt="...">
                        </div>
                        <div class="carousel-item">
                          <img src="..." class="d-block w-100" alt="...">
                        </div>
                      </div>
                      <button class="carousel-control-prev" type="button" data-target="#carouselIndicators-${item.ID}" data-slide="prev">
                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                      </button>
                      <button class="carousel-control-next" type="button" data-target="#carouselIndicators-${item.ID}" data-slide="next">
                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          `)
        })
        $('.btn-sm').css('cursor', 'pointer');
        $('#data-table').DataTable();

      },
      error: (res) => {
        let response = res.responseText.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        alert(responseJSON.message);
        window.history.back();
      }
    }).always(function(res){
      spinner.hide();
    })
  })
</script>