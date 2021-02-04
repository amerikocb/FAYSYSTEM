using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class Usuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarUsuarios_Lista();
        }

        protected void CargarUsuarios_Lista()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgUsuarios.DataSource = db.Usuario.ObtenerListaUsuarios();
                dgUsuarios.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgUsuarios.DataBind();
            }
        }
        protected void btnAgregarUsuarios_Click(object sender, EventArgs e)
        {
            pcUsuarios.ShowOnPageLoad = true;
            using (var db = new UnidadDeTrabajo())
            {
                cmbEmpleado.DataSource = db.Empleado.ObtenerListaEmpleados();
                cmbEmpleado.TextField = "NombreCompleto";
                cmbEmpleado.ValueField = "Id";
                cmbEmpleado.DataBind();

                cmbTipoUsuario.DataSource = db.TipoUsuario.Obtener();
                cmbTipoUsuario.DataBind();

                cmbEstado.DataSource = db.Estado.Obtener(te => te.IdTipoEstado == 15);
                cmbEstado.DataBind();
            }
        }

        protected void dgUsuarios_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    Usuario user = wu.Usuario.ObtenerPorId(int.Parse(dgUsuarios.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    break;

            }
        }

        protected void cpAdministracionUsuarios_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = db.Estado.Obtener(es => es.IdTipoEstado == 15);
                cmbEstado.DataBind();

                cmbTipoUsuario.DataSource = db.TipoUsuario.Obtener();
                cmbTipoUsuario.DataBind();

                cmbEmpleado.DataSource = db.Empleado.ObtenerListaEmpleados();
                cmbEmpleado.DataBind();
                if (campoO.Text == "1")
                {
                    Usuario user = db.Usuario.ObtenerUsuarioPorId(int.Parse(e.Parameter));
                    txtUsuario.Text = user.Nombre;
                    txtContraseña01.Text = user.Password.ToString();
                    txtContraseña02.Text = user.Password.ToString();
                    cmbTipoUsuario.Value = user.IdTipoUsuario;
                    cmbEstado.Value = user.IdEstado;
                    cmbEmpleado.Value = db.Empleado.Obtener_Empleado_x_IdPersona(user.Empleado.IdPersona).Id;
                    txtId.Value = user.id;
                }
                else
                {
                    txtUsuario.Text = null;
                    txtUsuario.Text = "";
                    txtContraseña01.Value = null;
                    txtContraseña01.Text = "";
                    txtContraseña02.Value = null;
                    cmbTipoUsuario.Value = null;
                    cmbEstado.Value = 33;
                    cmbEmpleado.Value = null;
                    txtId.Value = null;
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                if (campoO.Text == "1")
                {
                    try
                    {
                        //Empleado em = db.Empleado.ObtenerPorId(int.Parse(cmbEmpleado.Value.ToString()));
                        db.Usuario.ActualizarUsuario(int.Parse(txtId.Text.ToString()), txtUsuario.Text, txtContraseña02.Text, int.Parse(cmbEmpleado.Value.ToString()), int.Parse(cmbTipoUsuario.Value.ToString()), int.Parse(cmbEstado.Value.ToString()));
                        MostrarMensajes("Operación realizada con éxito");
                    }
                    catch (Exception ex)
                    {
                        MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);
                    }
                }
                else
                {
                    try
                    {
                        //Empleado em = db.Empleado.ObtenerPorId(int.Parse(cmbEmpleado.Value.ToString()));
                        db.Usuario.InsertarUsuario(txtUsuario.Text, txtContraseña02.Text, int.Parse(cmbEmpleado.Value.ToString()), int.Parse(cmbTipoUsuario.Value.ToString()), 33);
                        MostrarMensajes("Operación realizada con éxito");
                    }
                    catch(Exception ex)
                    {
                        MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);
                    }
                }
                pcUsuarios.ShowOnPageLoad = false;
                CargarUsuarios_Lista();
            }
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }

        protected void cpComprobarUser_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                if (db.Usuario.ObtenerUsuario_x_user(e.Parameter.ToString()))
                {
                    txtUsuario.IsValid = false;
                    txtUsuario.ErrorText = "El nombre de usuario ya está en uso!";
                }
                else
                {
                    txtUsuario.IsValid = true;
                    txtUsuario.ErrorText = null;
                }
            }
        }
    }
}