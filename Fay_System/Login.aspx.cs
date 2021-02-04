using LibreriaDatos;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Net.Http;
using System.IO;

namespace Fay_System
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AccesoFayceWindow.ShowOnPageLoad = true;
            txtUsuario.Focus();
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {

        }
        private List<string> ObtenerTipoDeCambio()
        {
            try
            {
                List<string> valores = new List<string>();
                HttpClient cliente = new HttpClient();
                cliente.BaseAddress = new Uri("https://e-consulta.sunat.gob.pe/");
                HttpResponseMessage rpta = cliente.GetAsync("cl-at-ittipcam/tcS01Alias").Result;
                if (rpta != null && rpta.IsSuccessStatusCode)
                {
                    string contenido = "";
                    using (MemoryStream ms = (MemoryStream)
                    rpta.Content.ReadAsStreamAsync().Result)
                    {
                        byte[] buffer = ms.ToArray();
                        contenido = Encoding.UTF8.GetString(buffer);
                        contenido = contenido.ToLower();
                    }
                    if (contenido.Length > 0)
                    {
                        //File.WriteAllText("Sunat.txt", contenido);
                        int posInicioT1 = contenido.IndexOf("<table");
                        int posFinT1 = contenido.IndexOf("</table");
                        if (posInicioT1 > -1 && posFinT1 > -1)
                        {
                            int posInicioT2 = contenido.IndexOf("<table", posInicioT1 + 1);
                            int posFinT2 = contenido.IndexOf("</table", posFinT1 + 1);
                            string tabla = contenido.Substring(posInicioT2, posFinT2 - posInicioT2 + 8);
                            //File.WriteAllText("Tabla.txt", tabla);
                            posInicioT1 = 0;
                            tabla = tabla.Replace("</strong>", "");

                            for (int i = 1; i < 4; i++)
                            {
                                posInicioT1 = tabla.LastIndexOf("</td");
                                if (posInicioT1 > -1)
                                {
                                    tabla = tabla.Substring(0, posInicioT1).Trim();
                                    posFinT1 = tabla.LastIndexOf(">");
                                    if (posFinT1 > -1)
                                    {
                                        valores.Add(tabla.Substring(posFinT1 + 1,
                                        tabla.Length - posFinT1 - 1).Trim());
                                    }
                                }
                            }
                        }
                    }
                }
                return valores;
            }
            catch (Exception)
            {
                return null;
            }
        }

        protected void cpValidateUser_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            Usuario usuario = new Usuario();
            using (var ut = new UnidadDeTrabajo())
            {
                usuario = ut.Usuario.ObtenerUsuarioPorNombreMasContraseña(txtUsuario.Text, txtPass.Text);
                if (usuario != null)
                {
                    Session["UserActive"] = usuario.Nombre;
                    Session["IdUserActive"] = usuario.id;
                    Session["IdTipoUserActive"] = usuario.IdTipoUsuario;
                    List<string> tipoCambio = ObtenerTipoDeCambio();
                    if (tipoCambio != null)
                        if (tipoCambio.Count > 0)
                            if (!string.IsNullOrEmpty(tipoCambio.ElementAt(0)))
                                ut.actualizarTipoCambio(double.Parse(tipoCambio.ElementAt(0)), double.Parse(tipoCambio.ElementAt(1)));
                    Response.RedirectLocation = "PaginaPrincipal.aspx";
                }
                else
                {
                    cpValidateUser.JSProperties["cpError"] = "El usuario o password ingresados son incorrectos!";
                }
            }
        }
    }
}