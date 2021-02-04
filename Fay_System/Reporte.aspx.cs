using Microsoft.Reporting.WebForms;
using System;
using System.Net;
using System.Security.Principal;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TestReportes
{
    public partial class Reporte : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ContentPlaceHolder cph = Master.FindControl("cphMenu") as ContentPlaceHolder;
            if (cph != null)
            {
                cph.Visible = false;
                //ASPxMenu menu = (ASPxMenu)cph.FindControl("MenuPrin");
                //if (menu != null)
                //{
                //    menu.Visible = false;
                //}
            }
            //Menu menu = (Menu)Page.Master.FindControl("MenuPrueba");
            //menu.MenuItemClick += Menu_MenuItemClick;
        }

        //private void Menu_MenuItemClick(object sender, MenuEventArgs e)
        //{
        //    Menu menu = (Menu)sender;
        //    MenuItem seleccionado = menu.SelectedItem;
        //    string nu = seleccionado.NavigateUrl;
        //}

        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // Set the processing mode for the ReportViewer to Remote
                MasterReportBasset.ProcessingMode = ProcessingMode.Remote;


                ServerReport serverReport = MasterReportBasset.ServerReport;
                //string filename = "Reporte";

                // Set the report server URL and report path
                //serverReport.ReportServerUrl = new Uri("http://desktop-ch9mk2j:80/ReportServer");
                serverReport.ReportServerUrl = new Uri("http://192.168.0.8:80/ReportServer");
                serverReport.ReportServerCredentials = new MyReportServerCredentials();
                if (Session["ItemClickeado"] != null)
                {
                    serverReport.ReportPath = "/Fayce/" + Session["ItemClickeado"].ToString();
                    switch (Session["ItemClickeado"].ToString())
                    {
                        case "RecepcionCompra":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            ReportParameter Idrecepcion = new ReportParameter("ParametroRecepcion", int.Parse(Request.QueryString["Recepcion"].ToString()).ToString());
                            serverReport.SetParameters(Idrecepcion);
                            RenderizarPDF();
                            //filename = "RecepcionCompra-" + string.Format("{0:00000000}", Idrecepcion);
                            break;
                        case "Cotizacion":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdCotizacion = new ReportParameter("ParametroCotizacion", int.Parse(Request.QueryString["Cot"].ToString()).ToString());
                            serverReport.SetParameters(IdCotizacion);
                            RenderizarPDF();
                            //filename = "Cotizacion-" + string.Format("{0:00000000}", IdCotizacion);
                            break;
                        case "Factura":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdCvFactura = new ReportParameter("ParametroComprobanteVenta", int.Parse(Request.QueryString["cv"].ToString()).ToString());
                            serverReport.SetParameters(IdCvFactura);
                            RenderizarPDF();
                            //filename = "Factura-" + string.Format("{0:00000000}", IdCvFactura);
                            break;
                        case "Boleta":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdCvBoleta = new ReportParameter("ParametroComprobanteVenta", int.Parse(Request.QueryString["cv"].ToString()).ToString());
                            serverReport.SetParameters(IdCvBoleta);
                            RenderizarPDF();
                            //filename = "Boleta-" + string.Format("{0:00000000}", IdCvBoleta);
                            break;
                        case "TicketVenta":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdCvTicket = new ReportParameter("ParametroComprobanteVenta", int.Parse(Request.QueryString["cv"].ToString()).ToString());
                            serverReport.SetParameters(IdCvTicket);
                            RenderizarPDF();
                            //filename = "TicketVenta-" + string.Format("{0:00000000}", IdCvTicket);
                            break;
                        case "Proforma":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter parOv= new ReportParameter("ParametroOrdenVenta", int.Parse(Request.QueryString["ovp"].ToString()).ToString());
                            serverReport.SetParameters(parOv);
                            RenderizarPDF();
                            //filename = "TicketVenta-" + string.Format("{0:00000000}", IdCvTicket);
                            break;
                        case "NotaCredito":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdCvNc = new ReportParameter("ParametroComprobanteVenta", int.Parse(Request.QueryString["cv"].ToString()).ToString());
                            serverReport.SetParameters(IdCvNc);
                            RenderizarPDF();
                            //filename = "TicketVenta-" + string.Format("{0:00000000}", IdCvTicket);
                            break;
                        case "SalidaMateriales":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdSalidaMaterial = new ReportParameter("ParametroSalidaMaterial", int.Parse(Request.QueryString["salma"].ToString()).ToString());
                            serverReport.SetParameters(IdSalidaMaterial);
                            RenderizarPDF();
                            //filename = "SalidaMaterial-" + string.Format("{0:00000000}", IdSalidaMaterial);
                            break;
                        case "OrdenTrabajo":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdOT = new ReportParameter("ParametroOrdenTrabajo", int.Parse(Request.QueryString["ot"].ToString()).ToString());
                            serverReport.SetParameters(IdOT);
                            RenderizarPDF();
                            //filename = "OrdenTrabajo-" + string.Format("{0:00000000}", IdOT);
                            break;
                        case "OrdenCompra":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdOC = new ReportParameter("ParametroOrdenCompra", int.Parse(Request.QueryString["idoc"].ToString()).ToString());
                            serverReport.SetParameters(IdOC);
                            RenderizarPDF();
                            //filename = "OrdenCompra-" + string.Format("{0:00000000}", IdOC);
                            break;
                        case "RequerimientoCompra":
                            MasterReportBasset.ShowParameterPrompts = false;
                            MasterReportBasset.AsyncRendering = false;
                            //MasterReportBasset.ShowParameterPrompts = false;
                            ReportParameter IdR = new ReportParameter("ParametroIdRequerimiento", int.Parse(Request.QueryString["Req"].ToString()).ToString());
                            ReportParameter IdsMat = new ReportParameter("ParametroIdMaterial");
                            IdsMat.Values.AddRange(Session["MaterialesReq"].ToString().Split(','));
                            serverReport.SetParameters(IdR);
                            serverReport.SetParameters(IdsMat);
                            RenderizarPDF();
                            //filename = "OrdenCompra-" + string.Format("{0:00000000}", IdOC);
                            break;
                        case "InventarioValorizado":
                            RenderizarPDF();
                            //filename = "InventarioValorizado-" + DateTime.Now.ToString();
                            break;
                        case "IngresosVentasPorFechas":
                            ReportParameter desde = new ReportParameter("ParametroDesde", Session["FechasVentas"].ToString().Split('|')[0]);
                            ReportParameter hasta = new ReportParameter("ParametroHasta", Session["FechasVentas"].ToString().Split('|')[1]);
                            serverReport.SetParameters(desde);
                            serverReport.SetParameters(hasta);
                            RenderizarPDF();
                            break;
                        case "IngresosEgresos":
                            ReportParameter fini = new ReportParameter("FECHAINI", Session["FechasIngresosEgresos"].ToString().Split('|')[0]);
                            ReportParameter ffin = new ReportParameter("FECHAFIN", Session["FechasIngresosEgresos"].ToString().Split('|')[1]);
                            serverReport.SetParameters(fini);
                            serverReport.SetParameters(ffin);
                            RenderizarPDF();
                            break;
                    }

                }

            }
        }

        public void RenderizarPDF()
        {
            Warning[] warnings;
            string[] streamIds;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string extension = string.Empty;

            byte[] bytes = MasterReportBasset.ServerReport.Render(
                "PDF",
                null,
                out mimeType,
                out encoding,
                out extension,
                out streamIds,
                out warnings);


            var ms = new System.IO.MemoryStream(bytes);
            Response.Buffer = true;
            Response.Clear();
            Response.ContentType = mimeType;
            //Response.AddHeader(
            //    "content-disposition",
            //    "attachment; filename= " + filename + "." + extension);
            Response.BinaryWrite(ms.ToArray()); // create the file  
            Response.Flush(); // send it to the client to download  
            Response.End();
        }

        [Serializable]
        public sealed class MyReportServerCredentials :
    IReportServerCredentials
        {
            public WindowsIdentity ImpersonationUser
            {
                get
                {
                    // Use the default Windows user.  Credentials will be
                    // provided by the NetworkCredentials property.
                    return null;
                }
            }

            public ICredentials NetworkCredentials
            {
                get
                {
                    string userName = "Administrador";
                    string password = "4dmin@2019";
                    //string domain = "192.168.0.8";

                    return new NetworkCredential(userName, password);
                }
            }

            public bool GetFormsCredentials(out Cookie authCookie,
                        out string userName, out string password,
                        out string authority)
            {
                authCookie = null;
                userName = null;
                password = null;
                authority = null;

                // Not using form credentials
                return false;
            }
        }
    }
}