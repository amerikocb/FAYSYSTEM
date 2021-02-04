using DevExpress.Web;
using LibreriaDatos.Fay_System;
using LibreriaDatos.Fay_System.DTO;
using System;
using System.Linq;

namespace Fay_System
{
    public partial class ComprobantesVenta : System.Web.UI.Page
    {
        string IdComprobanteVenta = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            IdComprobanteVenta = Request.QueryString["cv"];
            if (!string.IsNullOrEmpty(IdComprobanteVenta))
            {
                ComprobanteVenta cv = wu.ComprobanteVenta.ObtenerPorId(int.Parse(IdComprobanteVenta));
                if (wu.ComprobanteVenta.ObtenerNotasCreaditoAO_x_IdComprobante(cv.IdComprobanteVenta) == 0)
                {
                    OrdenVenta ov = wu.OrdenVenta.ObtenerPorId(cv.IdOrdenVenta);
                    txtComprobante.Text = cv.IdComprobanteVenta.ToString();
                    txtMotivo.Text = null;
                    deFecha.Value = DateTime.Now;

                    if (ov.TipoOrdenVenta.Contains("Trabajo"))
                    {
                        dgServiciosComprobante.DataSource = wu.ComprobanteVentaDetalle.ObtenerServiciosCv_x_IdComprobante(cv.IdComprobanteVenta);
                        dgServiciosComprobante.DataBind();
                        dgMaterialesComprobante.Visible = false;
                    }
                    else
                    {
                        dgMaterialesComprobante.DataSource = wu.ComprobanteVentaDetalle.ObtenerMaterialesCv_x_IdComprobante(cv.IdComprobanteVenta);
                        dgMaterialesComprobante.DataBind();
                        dgServiciosComprobante.Visible = false;
                    }
                    pcEmisorNotasCredito.ShowOnPageLoad = true;
                }
                else MostrarMensajes("El comprobante " + cv.Serie + "-" + string.Format("{0:00000000}", cv.Numero) + " ya tiene una nota de crédito asociada");
                
            }

        }

        protected void CargarComprobantes_Selecting(object sender, DevExpress.Data.Linq.LinqServerModeDataSourceSelectEventArgs e)
        {
            FayceEntities db = new FayceEntities();
            e.KeyExpression = "IdComprobanteVentaAuxiliar";
            e.DefaultSorting = "IdComprobanteVentaAuxiliar DESC";
            e.QueryableSource = from cv in db.ComprobanteVentaAuxiliar select cv;
            //e.QueryableSource = from cv in db.ComprobanteVenta
            //                    join p in db.Persona on cv.IdPersona equals p.Id
            //                    join mc in db.MotivoComprobante on cv.IdMotivoComprobante equals mc.IdMotivo
            //                    join es in db.Estado on cv.IdEstado equals es.Id
            //                    join u in db.Usuario on cv.IdUsuario equals u.id
            //                    select new DTOComprobantes
            //                    {
            //                        Id = cv.IdComprobanteVenta,
            //                        Fecha = cv.Fecha,
            //                        Serie = cv.Serie,
            //                        Numero = cv.Numero,
            //                        Cliente = p.TipoPersona != "NATURAL" ? p.RazonSocial : p.ApellidoPaterno + " " + p.ApellidoMaterno + ", " + p.Nombres,
            //                        Total = cv.Total,
            //                        Motivo = mc.Descripcion,
            //                        Observacion = cv.Observacion,
            //                        Estado = es.Descripcion,
            //                        Usuario = u.Nombre,
            //                        IdOrdenVenta = cv.IdOrdenVenta
            //                    };

        }

        protected void dgComprobantes_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "NotaCredito":
                    string url = "ComprobantesVenta.aspx?cv=" + int.Parse(dgComprobantes.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "VerReporte":
                    ComprobanteVenta cv = wu.ComprobanteVenta.ObtenerPorId(int.Parse(dgComprobantes.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    switch (cv.IdTipoDocumento)
                    {
                        case 1: //Factura
                            Session["ItemClickeado"] = "Factura";
                            break;
                        case 2: //Factura
                            Session["ItemClickeado"] = "Boleta";
                            break;
                        case 3: //Factura
                            Session["ItemClickeado"] = "TicketVenta";
                            break;
                        case 4:
                            Session["ItemClickeado"] = "NotaCredito";
                            break;
                    }
                    dgComprobantes.JSProperties["cpRedireccion"] = "Reporte.aspx?cv=" + cv.IdComprobanteVenta;
                    break;
            }
        }

        protected void btnApplyCreditNote_Click(object sender, EventArgs e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                try
                {
                    ComprobanteVenta cva = db.ComprobanteVenta.ObtenerPorId(int.Parse(txtComprobante.Text)); //Comprobante de venta afectado
                    ComprobanteVenta cv = new ComprobanteVenta
                    {
                        //{
                        Fecha = DateTime.Now,
                        IdPersona = cva.IdPersona,
                        Serie = cva.IdTipoDocumento == 1 ? "FC01" : cva.IdTipoDocumento == 2 ? "BC01" : "TC01",
                        Numero = 0,
                        Descuento = cva.Descuento,
                        Total = cva.Total,
                        IGV = 18,
                        FechaCreacion = DateTime.Now,
                        IdTipoDocumento = 4,
                        IdMotivoComprobante = 3,
                        IdTipoPago = 1,
                        IdCaja = 1,
                        Observacion = "Emitido",
                        IdEstado = 65,
                        IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                        IdOrdenVenta = cva.IdOrdenVenta,
                        IdComprobanteVentaRef = cva.IdComprobanteVenta,
                        MotivoNotaCredito = txtMotivo.Text
                    };

                    //};
                    db.ComprobanteVenta.Insertar(cv);
                    db.Grabar();
                    pcEmisorNotasCredito.ShowOnPageLoad = false;
                    dgComprobantes.DataBind();
                    MostrarMensajes("Operacion realizada con éxito");
                }
                catch (Exception ex)
                {

                    MostrarMensajes("Ha ocurrido un error inesperado: " + ex.Message);
                }
            }
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
    }
}