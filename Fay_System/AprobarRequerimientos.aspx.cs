using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Fay_System
{
    public partial class AprobarRequerimientos : System.Web.UI.Page
    {
        string NumeroRequerimiento = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            NumeroRequerimiento = Request.QueryString["Id"];
            ObtenerRequerimientos();
            using (var db = new UnidadDeTrabajo())
            {
                txtPrecioDolar.Text = db.ObenerPrecioDolar().ToString();
                if (NumeroRequerimiento != null && NumeroRequerimiento != "Nuevo")
                {
                    //r = db.Requerimiento.ObtenerPorId(int.Parse(NumeroRequerimiento));
                    if (int.Parse(NumeroRequerimiento) > 0)
                    {
                        dgRequerimientoDetalle.DataSource = db.RequerimientoDetalle.ObtenerDetalleRequerimiento(int.Parse(NumeroRequerimiento));
                        dgRequerimientoDetalle.DataBind();

                    }
                    //if (r.IdEstado == 26)
                    pcEditorRequerimientos.ShowOnPageLoad = true;
                }

                if (Session["IdUserActive"] != null)
                {
                    if (db.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 14) == true){
                        btnAprobarRequerimiento.ClientEnabled = false;
                        dgRequerimientoDetalle.SettingsEditing.Mode = GridViewEditingMode.Inline;
                        dgRequerimientoDetalle.Columns[0].Visible = false;
                    }
                }
            }
        }
        protected void ObtenerRequerimientos()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgRequerimientos.DataSource = db.Requerimiento.ObtenerListaRequerimientosPendientesDeAprobacion();
                dgRequerimientos.DataBind();
            }
        }
        protected void dgRequerimientoDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
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
            e.Handled = true;
            //pcEditorRequerimientos.ShowOnPageLoad = false;
        }

        protected void dgRequerimientos_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    string url = "AprobarRequerimientos.aspx?Id=" + int.Parse(dgRequerimientos.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "Anular":
                    try
                    {
                        Requerimiento Req_anular = wu.Requerimiento.ObtenerPorId(int.Parse(dgRequerimientos.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        Req_anular.IdEstado = 28;
                        wu.Requerimiento.Actualizar(Req_anular);
                        wu.Grabar();
                        MostrarMensajes("Operación realizada con éxito");
                    }
                    catch(Exception ex) { MostrarMensajes("Ha ocurrido un error: " + ex.Message); }
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
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void btnAprobarRequerimiento_Click(object sender, EventArgs e)
        {
            Requerimiento req_x_aprobar = new Requerimiento();
            try
            {
                NumeroRequerimiento = Request.QueryString["Id"];
                using (var db = new UnidadDeTrabajo())
                {
                    req_x_aprobar = db.Requerimiento.ObtenerPorId(int.Parse(NumeroRequerimiento));
                    if (req_x_aprobar.IdEstado == 27) MostrarMensajes("Este requerimiento ya ha sido aprobado");
                    else
                    {
                        req_x_aprobar.IdEstado = 27;
                        db.Requerimiento.Actualizar(req_x_aprobar);
                        db.Grabar();

                        //int numeroProvRequerimiento = db.RequerimientoDetalle.ObtenerProveedoresPorRequerimiento(req_x_aprobar.Id).Count;
                        List<int> IdsProveedores = db.RequerimientoDetalle.ObtenerProveedoresPorRequerimiento(req_x_aprobar.Id);
                        for (int i = 0; i < IdsProveedores.Count; i++)
                        {
                            OrdenCompra oc = new OrdenCompra
                            {
                                IdRequerimiento = req_x_aprobar.Id,
                                IdEstado = 10,
                                DocumentoReferencia = req_x_aprobar.DocumentoReferencia,
                                IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                                FechaCreacion = DateTime.Now,
                                Fecha = DateTime.Now,
                                TipoOrden = "",
                                IdEmpresa = IdsProveedores[i],
                            };
                            db.OrdenCompra.Insertar(oc);
                            db.Grabar();

                            db.OrdenCompraDetalle.InsertarOrdenCompraDetalle_x_OrdenCompra(oc, IdsProveedores[i]);
                        }
                        MostrarMensajes("Operación realizada con éxito");
                    }
                    pcEditorRequerimientos.ShowOnPageLoad = false;
                    ObtenerRequerimientos();
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
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
    }
}