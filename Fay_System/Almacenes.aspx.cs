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
    public partial class Almacenes : System.Web.UI.Page
    {
        //int idAlmacenInsertado = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarAlmacenes();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 9) == true)
                    {
                        btnAgregarAlmacen.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;

                    }
                }
            }
        }
        protected void cargarAlmacenes()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgAlmacenes.DataSource = db.Almacen.ObtenerAlmacenes();
                dgAlmacenes.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgAlmacenes.DataBind();
            }
        }
        protected void cpEditorAlmacenes_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = bd.Estado.Obtener(es => es.IdTipoEstado == 23);
                cmbEstado.DataBind();
                Almacen Almacen_a_editar = new Almacen();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter));
                }
                else
                {
                    txtId.Value = "";
                    txtDescripcion.Value = "";
                }
            }
        }
        private void actualizar_datos_de_edicion_y_de_lectura(int IdAlmacen)
        {
            txtId.ReadOnly = false;
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                Almacen AlmacenDetalle = bd.Almacen.ObtenerPorId(IdAlmacen);
                if (AlmacenDetalle != null)
                {
                    txtId.Value = AlmacenDetalle.Id;
                    txtDescripcion.Value = AlmacenDetalle.Descripcion;
                    cmbEstado.Value = AlmacenDetalle.IdEstado;
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Almacen Almacen = new Almacen();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        Almacen = bd.Almacen.ObtenerPorId(int.Parse(txtId.Text));
                        Almacen.Descripcion = txtDescripcion.Text;
                        Almacen.IdEstado = int.Parse(cmbEstado.Value.ToString());
                        bd.Almacen.Actualizar(Almacen);
                        bd.Grabar();
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
                    using (var bd = new UnidadDeTrabajo())
                    {
                        Almacen.Descripcion = txtDescripcion.Text;
                        Almacen.IdEstado = 51;
                        bd.Almacen.Insertar(Almacen);
                        bd.Grabar();
                    }
                    MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcAlmacenes.ShowOnPageLoad = false;
            cargarAlmacenes();
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgAlmacenes_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }
    }
}