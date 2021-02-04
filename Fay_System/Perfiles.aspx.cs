using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class Perfiles : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack || dgUsuarios.IsCallback)
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
                    txtContraseña01.Value = null;
                    txtContraseña02.Value = null;
                    cmbTipoUsuario.Value = null;
                    cmbEstado.Value = null;
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
                    catch (Exception ex)
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

        protected void dgOpcionesMenu_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            ASPxGridView grid = (ASPxGridView)sender;
            switch (e.Column.FieldName)
            {
                case "IdMenuHijo":
                    InitializeCombo(e, "IdMenuPadre", ObtenerOpcionesHijo, cmbCombo2_OnCallback, grid);
                    break;
                default:
                    break;
            }
        }
        protected void InitializeCombo(ASPxGridViewEditorEventArgs e,
        string parentComboName, SqlDataSource source, CallbackEventHandlerBase callBackHandler, ASPxGridView grid)
        {
            string id = string.Empty;
            if (!grid.IsNewRowEditing)
            {
                object val = grid.GetRowValuesByKeyValue(e.KeyValue, parentComboName);
                id = (val == null || val == DBNull.Value) ? null : val.ToString();
            }
            ASPxComboBox combo = e.Editor as ASPxComboBox;
            if (combo != null)
            {
                // unbind combo
                combo.DataSourceID = null;
                FillMenuHijoCombo(combo, id, source);
                combo.Callback += callBackHandler;
            }
            return;
        }

        private void cmbCombo2_OnCallback(object source, CallbackEventArgsBase e)
        {
            FillMenuHijoCombo(source as ASPxComboBox, e.Parameter, ObtenerOpcionesHijo);
        }
        protected void FillMenuHijoCombo(ASPxComboBox cmb, string id, SqlDataSource source)
        {
            cmb.Items.Clear();
            // trap null selection
            if (string.IsNullOrEmpty(id)) return;

            // get the values
            source.SelectParameters[0].DefaultValue = id;
            DataView view = (DataView)source.Select(DataSourceSelectArguments.Empty);
            using (var db = new UnidadDeTrabajo())
            {
                foreach (DataRowView row in view)
                {
                    if (!db.MenuPerfil.ObtenerCombinación_Admitida(id + "" + row[0] + Session["IdUserMenu"]))
                        cmb.Items.Add(row[1].ToString(), row[0]);
                }
            }
        }

        protected void dgOpcionesMenu_BeforePerformDataSelect(object sender, EventArgs e)
        {
            try
            {
                Session["IdUserMenu"] = (sender as ASPxGridView).GetMasterRowKeyValue();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

        }

        protected void dgOpcionesMenu_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView dg = (ASPxGridView)sender;
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    foreach (var item in e.InsertValues)
                    {
                        db.MenuPerfil.InsertarValoresMenuPerfil(item.NewValues, int.Parse(Session["IdUserMenu"].ToString()));
                    }

                    foreach (var item in e.UpdateValues)
                    {
                        db.MenuPerfil.ActualizarMenuPerfil(item.Keys, item.NewValues);
                    }
                    foreach (var item in e.DeleteValues)
                    {
                        db.MenuPerfil.EliminarMenuPerfil(item.Keys);
                    }
                }
                dg.JSProperties["cpOperacionesGrid"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                dg.JSProperties["cpOperacionesGrid"] = "Error: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void dgOpcionesMenu_Load(object sender, EventArgs e)
        {
            ASPxGridView Gv = (ASPxGridView)sender;
            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 4) == true)
                    {
                        Gv.SettingsEditing.Mode = GridViewEditingMode.Inline;
                    }
                }
            }
        }

        protected void dgOpcionesMenu_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data)
            {
                return;
            }

            string inact = e.GetValue("Descripcion").ToString();
            if (inact == "Inactivo")
            {
                e.Row.BackColor = System.Drawing.Color.BurlyWood;
            }
        }
    }
}