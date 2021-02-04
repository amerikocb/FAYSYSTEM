using DevExpress.Web;
using LibreriaDatos.Fay_System;
using LibreriaDatos.Fay_System.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Net.Http;
using System.IO;
using System.Text;
//using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class PaginaMaestra : MasterPage
    {
        private const string AntiXsrfTokenKey = "__AntiXsrfToken";
        private const string AntiXsrfUserNameKey = "__AntiXsrfUserName";
        private string _antiXsrfTokenValue;

        string[] itemsDeMenu;

        protected void Page_Init(object sender, EventArgs e)
        {
            // The code below helps to protect against XSRF attacks
            var requestCookie = Request.Cookies[AntiXsrfTokenKey];
            Guid requestCookieGuidValue;
            if (requestCookie != null && Guid.TryParse(requestCookie.Value, out requestCookieGuidValue))
            {
                // Use the Anti-XSRF token from the cookie
                _antiXsrfTokenValue = requestCookie.Value;
                Page.ViewStateUserKey = _antiXsrfTokenValue;
            }
            else
            {
                // Generate a new Anti-XSRF token and save to the cookie
                _antiXsrfTokenValue = Guid.NewGuid().ToString("N");
                Page.ViewStateUserKey = _antiXsrfTokenValue;

                var responseCookie = new HttpCookie(AntiXsrfTokenKey)
                {
                    HttpOnly = true,
                    Value = _antiXsrfTokenValue
                };
                if (FormsAuthentication.RequireSSL && Request.IsSecureConnection)
                {
                    responseCookie.Secure = true;
                }
                Response.Cookies.Set(responseCookie);
            }

            Page.PreLoad += master_Page_PreLoad;
        }

        protected void master_Page_PreLoad(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set Anti-XSRF token
                ViewState[AntiXsrfTokenKey] = Page.ViewStateUserKey;
                ViewState[AntiXsrfUserNameKey] = Context.User.Identity.Name ?? String.Empty;
            }
            else
            {
                // Validate the Anti-XSRF token
                if ((string)ViewState[AntiXsrfTokenKey] != _antiXsrfTokenValue
                    || (string)ViewState[AntiXsrfUserNameKey] != (Context.User.Identity.Name ?? String.Empty))
                {
                    throw new InvalidOperationException("Validation of Anti-XSRF token failed.");
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            deDesde.Value = DateTime.Now;
            deHasta.Value = DateTime.Now;
            if (Session["UserActive"] == null)
                Response.RedirectLocation = "Login.aspx";
            if (!Page.IsPostBack)
            {
                try
                {
                    ConstruirMenu(MenuPrin);
                }
                catch (Exception ex)
                {
                    Response.Redirect("Login.aspx");
                }
            }

        }

        protected void ConstruirMenu(ASPxMenu menu)
        {
            UnidadDeTrabajo workUnit = new UnidadDeTrabajo();
            // Get DataView
            //DataSourceSelectArguments arg = new DataSourceSelectArguments();
            DataTable menuDesdeBD = new DataTable();
            menuDesdeBD = workUnit.Menu.ObtenerMenuPorUsuario(int.Parse(Session["IdUserActive"].ToString()));
            //dataView.Sort = "ParentID";

            // Build Menu Items
            Dictionary<string, MenuItem> menuItems =
                new Dictionary<string, MenuItem>();

            for (int i = 0; i < menuDesdeBD.Rows.Count; i++)
            {
                DataRow row = menuDesdeBD.Rows[i];

                MenuItem item = CrearMenuItem(row);
                string itemID = row["IdMenu"].ToString();
                string parentID = row["IdMenuPadre"].ToString();

                if (menuItems.ContainsKey(parentID))
                    menuItems[parentID].Items.Add(item);
                else
                {
                    if (string.IsNullOrEmpty(parentID) || parentID == "0") // It's Root Item
                        menu.Items.Add(item);
                }
                menuItems.Add(itemID, item);
            }
            //menu.ItemClick += Menu_ItemClick;
        }
        public class ItemsDeMenu
        {
            public string NombreEnlace { get; set; }
            public string URL { get; set; }
        }

        private MenuItem CrearMenuItem(DataRow row)
        {
            MenuItem ret = new MenuItem
            {
                Text = row["NombreMenu"].ToString(),
                Name = row["IdMenu"].ToString()
            };
            if (ret.Text == "UsuarioActivo")
                ret.Text = Session["UserActive"].ToString().ToUpper();
            ret.Image.IconID = row["Icono"].ToString();
            return ret;
        }
        protected void MenuPrin_ItemClick(object source, MenuItemEventArgs e)
        {
            try
            {
                string url = "";
                switch (int.Parse(e.Item.Name))
                {
                    case 1: url = "~/PaginaPrincipal.aspx"; break;
                    case 3: url = "~/Usuarios.aspx"; break;
                    case 4: url = "~/Perfiles.aspx"; break;
                    case 5: url = "~/Empleados.aspx"; break;
                    case 6: url = "~/Empresas.aspx"; break;
                    case 8: url = "~/Materiales.aspx"; break;
                    case 9: url = "~/Almacenes.aspx"; break;
                    case 10: url = "~/AjustesInventario.aspx"; break;
                    case 11: url = "~/MovimientoMateriales.aspx"; break;
                    case 13: url = "~/Requerimientos.aspx"; break;
                    case 14: url = "~/AprobarRequerimientos.aspx"; break;
                    case 15: url = "~/OrdenesCompra.aspx"; break;
                    case 16: url = "~/Recepciones.aspx"; break;
                    case 18: url = "~/Cotizaciones.aspx"; break;
                    case 19: url = "~/OrdenesVenta.aspx"; break;
                    case 20: url = "~/OrdenesTrabajo.aspx"; break;
                    case 21: url = "~/Servicios.aspx"; break;
                    case 22: url = "~/Clientes.aspx"; break;
                    case 24: url = "~/Reporte.aspx"; break;
                    case 26: url = "~/Login.aspx"; break;
                    case 27: url = "~/SalidaMateriales.aspx"; break;
                    case 29: url = "~/UnidadesMedida.aspx"; break;
                    case 30: url = "~/ComprobantesVenta.aspx"; break;
                    case 31: url = "~/Reporte.aspx"; break;
                    case 32: url = "~/Transferencias.aspx"; break;
                    case 33: url = "~/EgresosMoney.aspx"; break;
                    default:
                        break;
                }
                Response.Redirect(url);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        protected void cpOpenReport_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            switch (int.Parse(e.Parameter.ToString().Split('|')[0]))
            {
                case 1:
                    FormsAuthentication.SignOut();
                    Session.RemoveAll();
                    Session.Abandon();
                    Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));
                    break;
                case 2:
                    Session["ItemClickeado"] = "InventarioValorizado";
                    cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?Inv_Val" + DateTime.Now.ToShortDateString();
                    break;
                case 3:
                    Session["ItemClickeado"] = "IngresosVentasPorFechas";
                    Session["FechasVentas"] = e.Parameter.ToString().Split('|')[1] + "|" + e.Parameter.ToString().Split('|')[2];
                    cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?IngVF";
                    break;
                case 4:
                    Session["ItemClickeado"] = "IngresosEgresos";
                    Session["FechasIngresosEgresos"] = e.Parameter.ToString().Split('|')[1] + "|" + e.Parameter.ToString().Split('|')[2];
                    cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?IngEgr";
                    break;
            }
        }
    }

}