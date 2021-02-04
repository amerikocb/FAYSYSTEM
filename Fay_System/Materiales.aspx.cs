using DevExpress.Web;
using LibreriaDatos.Fay_System;
using LibreriaDatos.Fay_System.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class Materiales : System.Web.UI.Page
    {
        int idMaterialInsertado = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarMateriales();
            using (var ut = new UnidadDeTrabajo())
            {
                if(Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 8) == true)
                    {
                        btnAgregarMaterial.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;
                    }
                }
            }
        }
        protected void cargarMateriales()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgMateriales.DataSource = db.Material.ObtenerMateriales();
                dgMateriales.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgMateriales.DataBind();
            }
        }
        protected void cpEditorMateriales_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = bd.Estado.Obtener(es => es.IdTipoEstado == 22);
                cmbEstado.DataBind();
                cmbAlmacen.DataSource = bd.Almacen.Obtener();
                cmbAlmacen.DataBind();
                Material Material_a_editar = new Material();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter.Split('|')[0]), int.Parse(e.Parameter.Split('|')[1]));
                }
                else
                {
                    txtId.Value = "";
                    txtDescripcion.Value = "";
                    txtObservacion.Text = "";
                    txtCosto.Value = "";
                    txtCodigo.Value = "";
                    txtPrecio.Value = "";
                }
            }
        }

        private void actualizar_datos_de_edicion_y_de_lectura(int IdMaterial, int IdAlmacen)
        {
            txtId.ReadOnly = false;
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                Material MaterialDetalle = bd.Material.ObtenerPorId(IdMaterial);
                if (MaterialDetalle != null)
                {
                    txtId.Value = MaterialDetalle.Id;
                    txtObservacion.Value = MaterialDetalle.Observacion;
                    txtCodigo.Value = MaterialDetalle.Codigo;
                    txtCosto.Value = MaterialDetalle.Costo;
                    txtDescripcion.Value = MaterialDetalle.Descripcion;
                    cmbEstado.Value = MaterialDetalle.IdEstado;
                    txtPrecio.Value = MaterialDetalle.Precio;
                    txtStock.Value = bd.Stock.ObtenerStock_MaterialAlmacen(IdMaterial, IdAlmacen);
                    cmbAlmacen.Value = IdAlmacen;
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Material Material = new Material();
            Persona persona = new Persona();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        AdministrarMaterial(1);
                        //AdministrarPersona(bd.Material.ObtenerPorId(int.Parse(txtId.Text)).IdPersona, 1);
                    }
                    MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al actualizar: " + ex.Message);
                }
            }
            else //Agregar
            {
                try
                {
                    AdministrarMaterial(2);
                    MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcMateriales.ShowOnPageLoad = false;
            cargarMateriales();
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgMateriales_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }
        protected int AdministrarMaterial(int Operacion)
        {
            try
            {
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Material MaterialActualizar = bd.Material.ObtenerPorId(int.Parse(txtId.Text));
                            MaterialActualizar.IdEstado = int.Parse(cmbEstado.Value.ToString());
                            MaterialActualizar.Descripcion = txtDescripcion.Text;
                            MaterialActualizar.Codigo = txtCodigo.Text;
                            MaterialActualizar.Costo = double.Parse(txtCosto.Text);
                            MaterialActualizar.Precio = double.Parse(txtPrecio.Text);
                            MaterialActualizar.Observacion = txtObservacion.Text;
                            MaterialActualizar.IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                            bd.Material.Actualizar(MaterialActualizar);
                            bd.Grabar();
                            idMaterialInsertado = 0;
                            break;
                        case 2:
                            var MaterialInsertar = new Material
                            {
                                Costo = double.Parse(txtCosto.Text),
                                Precio = double.Parse(txtPrecio.Text),
                                FechaCreacion = DateTime.Today,
                                IdEstado = 49,
                                Codigo = txtCodigo.Text,
                                Descripcion = txtDescripcion.Text,
                                Observacion = txtObservacion.Text,
                                IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,

                            };
                            bd.Material.Insertar(MaterialInsertar);
                            bd.Grabar();
                            idMaterialInsertado = MaterialInsertar.Id;
                            var StockInsertar = new Stock
                            {
                                IdAlmacen = int.Parse(cmbAlmacen.Value.ToString()),
                                IdMaterial = idMaterialInsertado,
                                Stock1 = 0,
                            };
                            bd.Stock.Insertar(StockInsertar);
                            bd.Grabar();
                            break;
                    }
                }
                MostrarMensajes("Operación realizada con éxito");
            }
            catch (Exception ex)
            {
                idMaterialInsertado = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en administración Materiales: " + ex.Message);
            }
            return idMaterialInsertado;
        }

        protected void dgMateriales_HtmlDataCellPrepared(object sender, ASPxGridViewTableDataCellEventArgs e)
        {
            if (e.DataColumn.FieldName != "UnitsStock") return;
            if (Convert.ToInt32(e.CellValue) <= 20)
            {
                e.Cell.BackColor = System.Drawing.Color.Red;
                e.Cell.ForeColor = System.Drawing.Color.White;
                e.Cell.Font.Bold = true;
            }
        }
    }
}