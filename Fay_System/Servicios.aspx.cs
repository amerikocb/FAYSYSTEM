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
    public partial class Servicios : System.Web.UI.Page
    {
        int idServicioInsertado = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarServicioes();
            using (var ut = new UnidadDeTrabajo())
            {
                if(Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 22) == true)
                    {
                        btnAgregarServicio.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;
                    }
                }
            }
        }
        protected void cargarServicioes()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgServicioes.DataSource = db.Servicio.ObtenerServicios();
                dgServicioes.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgServicioes.DataBind();
            }
        }
        protected void cpEditorServicioes_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = bd.Estado.Obtener(es => es.IdTipoEstado == 14);
                cmbEstado.DataBind();
                Servicio Servicio_a_editar = new Servicio();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter));
                }
                else
                {
                    txtId.Value = "";
                    txtDescripcion.Value = "";
                    txtObservacion.Text = "";
                    txtCodigo.Value = "";
                    txtPrecio.Value = "";
                }
            }
        }

        private void actualizar_datos_de_edicion_y_de_lectura(int IdServicio)
        {
            txtId.ReadOnly = false;
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                Servicio ServicioDetalle = bd.Servicio.ObtenerPorId(IdServicio);
                if (ServicioDetalle != null)
                {
                    txtId.Value = ServicioDetalle.Id;
                    txtObservacion.Value = ServicioDetalle.Observacion;
                    txtDescripcion.Value = ServicioDetalle.Descripcion;
                    cmbEstado.Value = ServicioDetalle.IdEstado;
                    txtPrecio.Value = ServicioDetalle.Precio;
                    txtCodigo.Value = ServicioDetalle.CodigoServicio;
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Servicio Servicio = new Servicio();
            Persona persona = new Persona();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        AdministrarServicio(1);
                        //AdministrarPersona(bd.Servicio.ObtenerPorId(int.Parse(txtId.Text)).IdPersona, 1);
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
                    AdministrarServicio(2);
                    MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcServicioes.ShowOnPageLoad = false;
            cargarServicioes();
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgServicioes_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }
        protected int AdministrarServicio(int Operacion)
        {
            try
            {
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Servicio ServicioActualizar = bd.Servicio.ObtenerPorId(int.Parse(txtId.Text));
                            ServicioActualizar.IdEstado = int.Parse(cmbEstado.Value.ToString());
                            ServicioActualizar.Descripcion = txtDescripcion.Text;
                            ServicioActualizar.Precio = double.Parse(txtPrecio.Text);
                            ServicioActualizar.Observacion = txtObservacion.Text;
                            ServicioActualizar.IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                            ServicioActualizar.CodigoServicio = txtCodigo.Text;
                            bd.Servicio.Actualizar(ServicioActualizar);
                            bd.Grabar();
                            idServicioInsertado = 0;
                            break;
                        case 2:
                            var ServicioInsertar = new Servicio
                            {
                                Precio = double.Parse(txtPrecio.Text),
                                FechaCreacion = DateTime.Today,
                                IdEstado = 31,
                                Descripcion = txtDescripcion.Text,
                                Observacion = txtObservacion.Text,
                                IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                                CodigoServicio = txtCodigo.Text
                            };
                            bd.Servicio.Insertar(ServicioInsertar);
                            bd.Grabar();
                            idServicioInsertado = ServicioInsertar.Id;

                            break;
                    }
                }
                MostrarMensajes("Operación realizada con éxito");
            }
            catch (Exception ex)
            {
                idServicioInsertado = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en administración Servicioes: " + ex.Message);
            }
            return idServicioInsertado;
        }
    }
}