
<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Products</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row mb-3">
      <div class="col-12">
        <a href="merchant/addProduct" class="btn-sm btn-primary mb-3">Add new product</a>
      </div>
    </div>
    <div class="row">
      <div class="col-12">
        <table class="table table-stripped text-dark" id="data-table" style="width:100%">
          <thead>
            <tr>
              <th>No</th>
              <th >Image</th>
              <th >Title</th>
              <th >Price</th>
              <th>Created</th>
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
              <td>${index + 1}</td>
              <td>
                <a type="button" class="btn-sm btn-primary" data-toggle="modal" data-target="#modal-image-${item.ID}">
                  <img src="${item.Images ? item.Images[0].Link : ''}" alt="${item.Images ? 'Image' : 'No Image'}" class="img-fluid" width="100px">
                </a>
              </td>
              <td>
                ${item.Title}
              </td>
              <td id="price-${item.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.Price)}</td>
              <td>${item.Created}</td>
              <td>
                <div class="radio">
                  <input label="Yes" type="radio" name="available-${item.ID}" value="yes" ${item.IsAvailable == 'yes' ? 'checked' : ''}>
                  <input label="No" type="radio" name="available-${item.ID}" value="no" ${item.IsAvailable == 'no' ? 'checked' : ''}>
                </div>
              </td>
              <td>
                <a class="btn-sm btn-warning text-white" id="edit-${item.ID}" href="merchant/editProduct/${item.ID}">Edit</a>
                <a class="btn-sm btn-danger text-white" id="delete-${item.ID}">Delete</a>
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

          $(`#delete-${item.ID}`).click(function(){
            console.log('as');
            Swal.fire({
              title: `Do you want to delete ${item.Title} ?`,
              showCancelButton: true,
            }).then((result) => {
              /* Read more about isConfirmed, isDenied below */
              if (result.isConfirmed) {
                spinner.show();
                $.post({
                  url: `product-api/destroy/${item.ID}`,
                  headers: {
                    ClientID: "61f0d060f1f163.13349246",
                    AccessToken : AccessToken
                  },
                  success: async (res) =>{
                    await Swal.fire('Delete!', '', 'success')
                    window.location.reload();
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
                  console.log(res);
                  spinner.hide();
                })
              }
            })
          })

          if(item.Images){
            $('#modal').append(`
            <!-- Modal -->
              <div class="modal fade" id="modal-image-${item.ID}" aria-labelledby="ModalLabel-${item.ID}" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered modal-lg">
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
                          ${item.Images.map((item, index)=>{
                            return (`
                              <li data-target="#carouselIndicators-${item.ID}" data-slide-to="${index}" class="${index == 0 ? 'active' : ''}"></li>
                            `)
                          }).join('')}
                          
                        </ol>
                        <div class="carousel-inner">
                          ${item.Images.map((item, index)=>{
                            return (`
                              <div class="carousel-item ${index == 0 ? 'active' : ''}">
                                <img src="${item.Link}" class="d-block w-100" alt="...">
                              </div>
                            `)
                          }).join('')}
                        </div>
                        <a class="carousel-control-prev" type="button" data-target="#carouselIndicators-${item.ID}" data-slide="prev">
                          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                          <span class="sr-only">Previous</span>
                        </a>
                        <a class="carousel-control-next" type="button" data-target="#carouselIndicators-${item.ID}" data-slide="next">
                          <span class="carousel-control-next-icon" aria-hidden="true"></span>
                          <span class="sr-only">Next</span>
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            `)
          }
          
        })
        $('.btn-sm').css('cursor', 'pointer');
        
        $('#data-table').DataTable({
          "columnDefs": [
            {"targets":0, "type":"num"},
            {"targets":3, "type":"date-eu"},
            {"targets":[1, 5, 6], "orderable" : false},
          ],
        });
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