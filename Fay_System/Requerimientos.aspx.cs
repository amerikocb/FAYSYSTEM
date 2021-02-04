using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace Fay_System
{
    public partial class Requerimientos : System.Web.UI.Page
    {
        string NumeroRequerimiento = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            NumeroRequerimiento = Request.QueryString["Id"];
            txtPrecioDolar.Text = wu.ObenerPrecioDolar().ToString();
            cargarRequerimientos();
            if (NumeroRequerimiento == "Nuevo")
            {
                dgRequerimientoDetalle.DataSource = wu.RequerimientoDetalle.ObtenerDetalleRequerimiento(0);
                dgRequerimientoDetalle.DataBind();
                pcEditorRequerimientos.ShowOnPageLoad = true;
            }
            if (NumeroRequerimiento != null && NumeroRequerimiento != "Nuevo")
            {
                //txtPrecioDolar.Text = wu.Requerimiento.ObtenerPorId(int.Parse(NumeroRequerimiento)).PrecioDolar.ToString();
                if (int.Parse(NumeroRequerimiento) > 0)
                {
                    dgRequerimientoDetalle.DataSource = wu.RequerimientoDetalle.ObtenerDetalleRequerimiento(int.Parse(NumeroRequerimiento));
                    dgRequerimientoDetalle.DataBind();

                    int?[] estateBad = { 27, 28 };
                    Requerimiento r = wu.Requerimiento.ObtenerPorId(int.Parse(NumeroRequerimiento));

                    if (estateBad.Contains(r.IdEstado))
                    {
                        dgRequerimientoDetalle.SettingsEditing.Mode = GridViewEditingMode.Inline;
                        dgRequerimientoDetalle.Columns[0].Visible = false;
                    }
                }
                pcEditorRequerimientos.ShowOnPageLoad = true;
            }

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 13) == true)
                    {
                        addRequerimiento.ClientEnabled = false;
                        dgRequerimientoDetalle.SettingsEditing.Mode = GridViewEditingMode.Inline;
                        dgRequerimientoDetalle.Columns[0].Visible = false;
                    }
                }
            }
        }
        protected void cargarRequerimientos()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgRequerimientos.DataSource = db.Requerimiento.ObtenerListaRequerimientos();
                dgRequerimientos.DataBind();
            }
        }
        protected void addRequerimiento_Click(object sender, EventArgs e)
        {
            string url = "Requerimientos.aspx?Id=Nuevo";
            Response.Redirect(url);
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgRequerimientoDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                NumeroRequerimiento = Request.QueryString["Id"];
                using (var db = new UnidadDeTrabajo())
                {
                    if (NumeroRequerimiento == "Nuevo")
                    {
                        Requerimiento req = new Requerimiento
                        {
                            Fecha = DateTime.Now,
                            FechaCreacion = DateTime.Now,
                            IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                            TipoRequerimiento = "",
                            DocumentoReferencia = "",
                            IdEstado = 26,
                        };
                        db.Requerimiento.Insertar(req);
                        db.Grabar();
                        foreach (var item in e.InsertValues)
                        {
                            db.RequerimientoDetalle.InsertarValoresRequerimientoDetalle(item.NewValues, req.Id, decimal.Parse(txtPrecioDolar.Text));
                        }
                        NumeroRequerimiento = req.Id.ToString();
                        string url = "Requerimientos.aspx?Id=" + NumeroRequerimiento;
                        Response.RedirectLocation = url;
                    }
                    else
                    {
                        foreach (var item in e.InsertValues)
                        {
                            db.RequerimientoDetalle.InsertarValoresRequerimientoDetalle(item.NewValues, int.Parse(NumeroRequerimiento.ToString()), decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.UpdateValues)
                        {
                            db.RequerimientoDetalle.ActualizarRequerimientoDetalle(item.Keys, item.NewValues);
                        }
                        foreach (var item in e.DeleteValues)
                        {
                            db.RequerimientoDetalle.EliminarRequerimientoDetalle(item.Keys);
                        }
                    }
                    dgRequerimientoDetalle.DataSource = db.RequerimientoDetalle.ObtenerDetalleRequerimiento(int.Parse(NumeroRequerimiento));
                    dgRequerimientoDetalle.DataBind();
                }
                dgRequerimientoDetalle.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                dgRequerimientoDetalle.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void dgRequerimientos_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    string url = "Requerimientos.aspx?Id=" + int.Parse(dgRequerimientos.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "Anular":
                    try
                    {
                        Requerimiento Req_anular = wu.Requerimiento.ObtenerPorId(int.Parse(dgRequerimientos.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        if (Req_anular.IdEstado == 27) dgRequerimientos.JSProperties["cpOperacionGrid"] = "Operación denegada, el requerimiento ya ha sido aprobado";
                        else if (Req_anular.IdEstado == 28) dgRequerimientos.JSProperties["cpOperacionGrid"] = "Operación denegada, el requerimiento ya ha sido anulado";
                        else
                        {
                            Req_anular.IdEstado = 28;
                            wu.Requerimiento.Actualizar(Req_anular);
                            wu.Grabar();
                            cargarRequerimientos();
                            dgRequerimientos.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
                        }
                    }
                    catch (Exception ex) { dgRequerimientos.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error: " + ex.Message; }
                    break;
                case "VerReporte":

                    break;
            }
        }

        //protected void dgRequerimientoDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        //{
        //    UnidadDeTrabajo wu = new UnidadDeTrabajo();

        //    int?[] estateBad = { 27, 28 };
        //    if (NumeroRequerimiento != null && NumeroRequerimiento != "Nuevo")
        //    {
        //        NumeroRequerimiento = Request.QueryString["Id"];
        //        if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && estateBad.Contains(wu.Requerimiento.ObtenerEstadoRequerimiento(int.Parse(NumeroRequerimiento))))
        //            e.Visible = false;
        //    }
        //}

        protected void dgRequerimientos_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.ButtonID == "Anular")
            {
                using (var ut = new UnidadDeTrabajo())
                {
                    if (Session["IdUserActive"] != null)
                    {
                        if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 13) == true)
                        {
                            e.Visible = DevExpress.Utils.DefaultBoolean.False;
                        }
                    }
                }
            }
        }

        protected void cpGetPrecioMaterial_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioMaterial.JSProperties["cpStockM"] = ut.Material.ObtenerPrecioMaterial_X_Requerimiento(int.Parse(e.Parameter.ToString().Split('|')[0]), int.Parse(e.Parameter.ToString().Split('|')[1])).ToString();
            }
        }

        protected void dgRequerimientoDetalle_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "IdMaterial")
                e.Editor.ClientInstanceName = "MaterialEditor";
            if (e.Column.FieldName != "IdUnidadMedida")
                return;
            var editor = (ASPxComboBox)e.Editor;
            editor.ClientInstanceName = "UnidadMedidaEditor";
            editor.ClientSideEvents.EndCallback = "UnidadMedida_EndCallback";

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
            int servicioValue = GetCurrentMaterial();
            if (servicioValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Material(servicioValue);
                    combo.DataBind();
                }
            }

        }

        private int GetCurrentMaterial()
        {
            object id = null;
            if (hf.TryGet("CurrentMaterial", out id))
                return Convert.ToInt32(id);
            return -1;
        }

        protected void cpCargaListaMaterialesR_Callback(object sender, CallbackEventArgsBase e)
        {
            using (var wu = new UnidadDeTrabajo())
            {
                Requerimiento ReqRep = wu.Requerimiento.ObtenerPorId(int.Parse(e.Parameter.ToString()));
                txtIdReq.Text = string.Format("{0:00000000}", ReqRep.Id);
                lbxListaMateriales.DataSource = wu.RequerimientoDetalle.ObtenerMaterialesRequerimiento(ReqRep.Id);
                lbxListaMateriales.DataBind();
            }
        }

        protected void cpOpenReport_Callback(object sender, CallbackEventArgsBase e)
        {
            Session["MaterialesReq"] = hfListaMat.Get("ListaMat").ToString();
            Session["ItemClickeado"] = "RequerimientoCompra";
            cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?Req=" + int.Parse(txtIdReq.Text);
        }
    }
}