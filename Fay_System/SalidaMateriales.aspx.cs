using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class SalidaMateriales : System.Web.UI.Page
    {
        string NumeroSalidaMaterial = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();

            cmbOrdenesTrabajo.DataSource = wu.OrdenTrabajo.ObtenerListaOrdenesTrabajo_SalidaMateriales();
            cmbOrdenesTrabajo.ValueField = "Id";
            cmbOrdenesTrabajo.DataBind();

            NumeroSalidaMaterial = Request.QueryString["Id"];
            cargarSalidaMateriales();
            if (pcListadoEmpresas.IsCallback || dgEmpresas.IsCallback)
            {
                dgEmpresas.DataSource = wu.Empresa.ObtenerListaEmpresas();
                dgEmpresas.DataBind();
            }
            if (pcListadoClientes.IsCallback || dgClientes.IsCallback)
            {
                dgClientes.DataSource = wu.Cliente.ObtenerListaClientes();
                dgClientes.DataBind();
            }
            if (NumeroSalidaMaterial == "Nuevo")
            {
                //rbOpciones.Value = 1;
                dgSalidaMaterialDetalle.DataSource = wu.SalidaMaterialesDetalle.ObtenerDetalleSalidaMateriales(0);
                dgSalidaMaterialDetalle.DataBind();

                cmbEmpleado.DataSource = wu.Empleado.ObtenerListaEmpleados();
                cmbEmpleado.DataBind();
                pcEditorSalidaMateriales.ShowOnPageLoad = true;
            }
            if (NumeroSalidaMaterial != null && NumeroSalidaMaterial != "Nuevo")
            {
                cmbEmpleado.DataSource = wu.Empleado.ObtenerListaEmpleados();
                cmbEmpleado.DataBind();
                hfIdSalidaMaterial["IdSalidaMaterial"] = NumeroSalidaMaterial;
                if (int.Parse(NumeroSalidaMaterial) > 0)
                {
                    int?[] estateBad = { 36, 47, 67 };

                    SalidaMaterial cot = new SalidaMaterial();
                    using (var bd = new UnidadDeTrabajo())
                    {
                        cot = bd.SalidaMaterial.ObtenerPorId(int.Parse(NumeroSalidaMaterial));
                        cmbTipoSalida.Value = cot.TipoSalidaMaterial;
                        if (cot.TipoSalidaMaterial == "PrestamoMateriales")
                        {
                            if (cot.IdClienteNatural > 0)
                            {
                                Cliente cliente = bd.Cliente.ObtenerPorId(cot.IdClienteNatural);
                                txtApelNomRazSoc.Text = cliente.Persona.ApellidoPaterno + " " + cliente.Persona.ApellidoMaterno + ", " + cliente.Persona.Nombres;
                                txtRucDni.Text = cliente.Persona.DNI;
                                hfRucDni["rucDni"] = cliente.Persona.DNI;
                                rbOpciones.Value = 1;
                                lblApelNomRazSoc.Text = "Apell. Nombres:";
                                lblRucDni.Text = "DNI:";
                            }
                            else
                            {
                                Empresa empresa = bd.Empresa.ObtenerPorId(cot.IdClienteJuridico);
                                txtApelNomRazSoc.Text = empresa.Persona.RazonSocial;
                                txtRucDni.Text = empresa.Persona.Ruc;
                                hfRucDni["rucDni"] = empresa.Persona.Ruc;
                                rbOpciones.Value = 2;
                                lblApelNomRazSoc.Text = "Razón Social:";
                                lblRucDni.Text = "RUC:";
                            }
                        }
                        else
                        {
                            cmbOrdenesTrabajo.Value = cot.IdOrdenTrabajo;
                            cmbEmpleado.Value = cot.IdEmpleado;
                        }
                        hfOt["IdOt"] = cot.IdOrdenTrabajo;
                        cmbOrdenesTrabajo.ReadOnly = true;
                        if (estateBad.Contains(cot.IdEstado))
                        {
                            dgSalidaMaterialDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                            dgSalidaMaterialDetalle.Columns[0].Visible = false;
                        }
                        dgSalidaMaterialDetalle.DataSource = bd.SalidaMaterialesDetalle.ObtenerDetalleSalidaMateriales(int.Parse(NumeroSalidaMaterial));
                        dgSalidaMaterialDetalle.DataBind();
                    }

                    txtApelNomRazSoc.ClientEnabled = false;
                    txtRucDni.ClientEnabled = false;
                    rbOpciones.ClientEnabled = false;
                }
                pcEditorSalidaMateriales.ShowOnPageLoad = true;
            }
            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 27) == true)
                    {
                        btnBuscarPersonas.ClientEnabled = false;
                        addSalidaMateriales.ClientEnabled = false;
                        dgSalidaMaterialDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                        dgSalidaMaterialDetalle.Columns[0].Visible = false;
                    }
                }
            }
        }
        protected void cargarSalidaMateriales()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgSalidaMateriales.DataSource = db.SalidaMaterial.ObtenerListaSalidaMateriales();
                dgSalidaMateriales.DataBind();
            }
        }
        protected void addSalidaMateriales_Click(object sender, EventArgs e)
        {
            string url = "SalidaMateriales.aspx?Id=Nuevo";
            Response.Redirect(url);
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgSalidaMaterialDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                NumeroSalidaMaterial = Request.QueryString["Id"];
                using (var db = new UnidadDeTrabajo())
                {
                    if (NumeroSalidaMaterial == "Nuevo")
                    {
                        int? idClienteN = null, IdClienteJ = null;
                        SalidaMaterial sm = new SalidaMaterial();

                        sm.Fecha = DateTime.Now;
                        sm.FechaCreacion = DateTime.Now;
                        if (cmbTipoSalida.Value.ToString() == "PrestamoMateriales")
                        {
                            if (int.Parse(rbOpciones.Value.ToString()) == 1) { idClienteN = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                            if (int.Parse(rbOpciones.Value.ToString()) == 2) { IdClienteJ = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                            sm.IdClienteNatural = idClienteN;
                            sm.IdClienteJuridico = IdClienteJ;
                        }
                        else
                        {
                            sm.IdEmpleado = int.Parse(cmbEmpleado.Value.ToString());
                            sm.IdOrdenTrabajo = int.Parse(cmbOrdenesTrabajo.Value.ToString());
                        }
                        sm.IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                        sm.TipoSalidaMaterial = cmbTipoSalida.Value.ToString();
                        sm.DocumentoReferencia = "";
                        sm.IdEstado = 60;

                        db.SalidaMaterial.Insertar(sm);
                        db.Grabar();
                        foreach (var item in e.InsertValues)
                        {
                            db.SalidaMaterialesDetalle.InsertarValoresSalidaMaterialDetalle(item.NewValues, sm.Id, 0);
                        }
                        NumeroSalidaMaterial = sm.Id.ToString();
                        string url = "SalidaMateriales.aspx?Id=" + NumeroSalidaMaterial;
                        Response.RedirectLocation = url;
                    }
                    else
                    {
                        foreach (var item in e.InsertValues)
                        {
                            db.SalidaMaterialesDetalle.InsertarValoresSalidaMaterialDetalle(item.NewValues, int.Parse(NumeroSalidaMaterial.ToString()), 0);
                        }
                        foreach (var item in e.UpdateValues)
                        {
                            db.SalidaMaterialesDetalle.ActualizarSalidaMaterialesDetalle(item.Keys, item.NewValues, 0);
                        }
                        foreach (var item in e.DeleteValues)
                        {
                            db.SalidaMaterialesDetalle.EliminarSalidaMaterialDetalle(item.Keys);
                        }
                    }
                    dgSalidaMaterialDetalle.DataSource = db.SalidaMaterialesDetalle.ObtenerDetalleSalidaMateriales(int.Parse(NumeroSalidaMaterial));
                    dgSalidaMaterialDetalle.DataBind();
                }
                dgSalidaMaterialDetalle.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
                //cargarSalidaMateriales();
            }
            catch (Exception ex)
            {
                dgSalidaMaterialDetalle.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
            pcEditorSalidaMateriales.ShowOnPageLoad = false;
        }

        protected void dgSalidaMateriales_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            dgSalidaMateriales.JSProperties["cpOperacionesCot"] = null;
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    string url = "SalidaMateriales.aspx?Id=" + int.Parse(dgSalidaMateriales.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "Anular":
                    try
                    {
                        //SalidaMateriales Cot_anular = wu.SalidaMateriales.ObtenerPorId(int.Parse(dgSalidaMateriales.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        //Cot_anular.IdEstado = 36;
                        //wu.SalidaMaterial.Actualizar(Cot_anular);
                        wu.Grabar();
                        cargarSalidaMateriales();
                        dgSalidaMateriales.JSProperties["cpOperacionesCot"] = "Operación realizada con éxito";
                    }
                    catch (Exception ex)
                    {
                        dgSalidaMateriales.JSProperties["cpOperacionesCot"] = "Ha ocurrido un error inesperado: " + ex.Message;
                    }

                    break;
                case "VerReporteSM":
                    Session["ItemClickeado"] = "SalidaMateriales";
                    dgSalidaMateriales.JSProperties["cpRedireccion"] = "Reporte.aspx?salma=" + int.Parse(dgSalidaMateriales.GetRowValues(e.VisibleIndex, "Id").ToString());
                    break;
            }
        }
        //protected void dgSalidaMaterialDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        //{
        //    UnidadDeTrabajo wu = new UnidadDeTrabajo();

        //    int?[] estateBad = { 36, 47 };
        //    if (NumeroSalidaMaterial != null && NumeroSalidaMaterial != "Nuevo")
        //    {
        //        NumeroSalidaMaterial = Request.QueryString["Id"];
        //        if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && estateBad.Contains(wu.SalidaMaterial.ObtenerEstadoSalidaMateriales(int.Parse(NumeroSalidaMaterial))))
        //            e.Visible = false;
        //    }
        //}
        protected void generico_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }

        protected void cpGetPrecioMaterial_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioMaterial.JSProperties["cpPrecioS"] = ut.Material.ObtenerPrecioMaterial(int.Parse(e.Parameter.Split('|')[0]), int.Parse(e.Parameter.Split('|')[1])).ToString();
            }
        }

        protected void cpGeStockMaterial_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioMaterial.JSProperties["cpStockM"] = ut.Material.ObtenerStockMaterial(int.Parse(e.Parameter.ToString().Split('|')[0]), int.Parse(e.Parameter.ToString().Split('|')[1])).ToString();
            }
        }
        protected void dgSalidaMaterialDetalle_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "IdAlmacen")
                e.Editor.ClientInstanceName = "AlmacenEditor";
            else if (e.Column.FieldName == "IdMaterial")
            {
                var editor = (ASPxComboBox)e.Editor;
                editor.ClientInstanceName = "MaterialEditor";
                editor.ClientSideEvents.EndCallback = "Material_EndCallback";
            }
            else if (e.Column.FieldName == "IdUnidadMedida")
            {
                var editor1 = (ASPxComboBox)e.Editor;
                editor1.ClientInstanceName = "UnidadMedidaEditor";
                editor1.ClientSideEvents.EndCallback = "UnidadMedida_EndCallback";
            }
            else return;
        }

        protected void cmbMaterial_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            int id;
            if (e.Value == null || !int.TryParse(e.Value.ToString(), out id))
                return;
            ASPxComboBox combo = source as ASPxComboBox;
            using (var db = new UnidadDeTrabajo())
            {
                combo.DataSource = db.Material.ObtenerMaterial_x_Id(id);
                combo.DataBind();
            }
        }

        protected void cmbMaterial_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            ASPxComboBox combo = source as ASPxComboBox;
            int almacenValue = GetCurrentAlmacen();
            if (almacenValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.Material.Obtener_DTOMaterial_x_idAlmacen(almacenValue);
                    combo.DataBind();
                }
            }

        }

        protected void cmbUnidadMedida_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            int id;
            if (e.Value == null || !int.TryParse(e.Value.ToString(), out id))
                return;
            ASPxComboBox combo = source as ASPxComboBox;
            using (var db = new UnidadDeTrabajo())
            {
                combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Id(id);
                combo.DataBind();
            }
        }

        protected void cmbUnidadMedida_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            ASPxComboBox combo = source as ASPxComboBox;
            int materialValue = GetCurrentMaterial();
            if (materialValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Material(materialValue);
                    combo.DataBind();
                }
            }

        }

        private int GetCurrentAlmacen()
        {
            if (hf.TryGet("CurrentAlmacen", out object id))
                return Convert.ToInt32(id);
            return -1;
        }

        private int GetCurrentMaterial()
        {
            if (hf1.TryGet("CurrentMaterial", out object id))
                return Convert.ToInt32(id);
            return -1;
        }
    }
}