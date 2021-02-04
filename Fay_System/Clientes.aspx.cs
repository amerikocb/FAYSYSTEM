using LibreriaDatos.DTO;
using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class Clientes : System.Web.UI.Page
    {
        int idClienteInsertado = 0, IdPersonaInsertada = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarClientes_Listado();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 22) == true)
                    {
                        btnAgregarClientes.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;

                    }
                }
            }
        }

        protected void CargarClientes_Listado()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgClientes.DataSource = db.Cliente.ObtenerListaClientes();
                dgClientes.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgClientes.DataBind();
            }
        }

        protected void btnAgregarClientes_Click(object sender, EventArgs e)
        {
            pcClientes.ShowOnPageLoad = true;
        }

        protected void cpEditorClientes_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                cmbDepartamento.DataSource = bd.Departamento.Obtener();
                cmbDepartamento.DataBind();
                //cmbProvincia.ReadOnly = true;
                Cliente cliente_a_editar = new Cliente();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter));

                }
                else
                {
                    txtNombre.Text = "";
                    txtApPaterno.Text = "";
                    txtApMaterno.Text = "";
                    deFechaNacimiento.Text = "";
                    txtDni.Text = "";
                    txtRuc.Text = "";
                    txtTelefono.Text = "";
                    txtDireccion.Text = "";
                    txtEmail.Text = "";
                    txtId.Text = "";
                    cmbEstado.Value = 15;
                    cmbDepartamento.Value = 6;
                    cmbProvincia.DataSource = bd.Provincia.ObtenerProvinciasPorDepartamento(int.Parse(cmbDepartamento.Value.ToString()));
                    cmbProvincia.DataBind();
                    cmbProvincia.Value = 54;
                }
            }
        }


        private void actualizar_datos_de_edicion_y_de_lectura(int IdCliente)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                DTOCliente clienteDetalle = bd.Cliente.Obtener_DTOCliente_x_idCliente(IdCliente);
                if (clienteDetalle != null)
                {
                    txtId.Value = clienteDetalle.IdCliente;
                    txtNombre.Text = clienteDetalle.Nombres;
                    txtApPaterno.Text = clienteDetalle.ApellidoPaterno;
                    txtApMaterno.Text = clienteDetalle.ApellidoMaterno;
                    txtDni.Text = clienteDetalle.Dni;
                    deFechaNacimiento.Value = clienteDetalle.FechaNacimiento;
                    txtTelefono.Text = clienteDetalle.Telefono;
                    txtDireccion.Text = clienteDetalle.Direccion;
                    txtEmail.Text = clienteDetalle.Email;
                    cmbEstado.Value = clienteDetalle.IdEstado;
                    cmbProvincia.Value = clienteDetalle.IdProvincia;
                    cmbDepartamento.Value = clienteDetalle.IdDepartamento;
                    cmbProvincia.DataSource = bd.Provincia.ObtenerProvinciasPorDepartamento(clienteDetalle.IdDepartamento);
                    cmbProvincia.DataBind();
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Cliente cliente = new Cliente();
            Persona persona = new Persona();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        AdministrarCliente(0, 1);
                        AdministrarPersona(bd.Cliente.ObtenerPorId(int.Parse(txtId.Text)).IdPersona, 1);
                    }
                    //MostrarMensajes("Operación realizada con éxito");
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
                    AdministrarCliente(AdministrarPersona(0, 2), 2);
                    //MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcClientes.ShowOnPageLoad = false;
            CargarClientes_Listado();
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgEmpresas_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }
        protected int AdministrarPersona(int IdPersona, int Operacion)
        {
            try
            {
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Persona persona = bd.Persona.ObtenerPorId(IdPersona);

                            persona.FechaCreacion = DateTime.Today;
                            persona.Nombres = txtNombre.Text;
                            persona.ApellidoPaterno = txtApPaterno.Text;
                            persona.ApellidoMaterno = txtApMaterno.Text;
                            persona.FechaNacimiento = Convert.ToDateTime(deFechaNacimiento.Text);
                            persona.DNI = txtDni.Text;
                            persona.Sexo = cmbSexo.Text;
                            persona.IdProvincia = Convert.ToInt32(cmbProvincia.Value);
                            persona.Ruc = txtRuc.Text;
                            persona.Telefono = txtTelefono.Text;
                            persona.Direccion = txtDireccion.Text;
                            persona.Email = txtEmail.Text;

                            bd.Persona.Actualizar(persona);
                            bd.Grabar();
                            IdPersonaInsertada = 0;
                            break;
                        case 2:
                            if (bd.Persona.ObtenerPersonaCliente_x_DNI(txtDni.Text) == false)
                            {
                                var personaNueva = new Persona
                                {
                                    FechaCreacion = DateTime.Today,
                                    Nombres = txtNombre.Text,
                                    ApellidoPaterno = txtApPaterno.Text,
                                    ApellidoMaterno = txtApMaterno.Text,
                                    DNI = txtDni.Text,
                                    Sexo = cmbSexo.Text,
                                    IdProvincia = Convert.ToInt32(cmbProvincia.Value),
                                    Ruc = txtRuc.Text,
                                    Telefono = txtTelefono.Text,
                                    Direccion = txtDireccion.Text,
                                    Email = txtEmail.Text,
                                    RazonSocial = (txtNombre.Text + txtApPaterno.Text + txtApMaterno.Text).ToUpper(),
                                    TipoPersona = "NATURAL"
                                };
                                if (!string.IsNullOrEmpty(deFechaNacimiento.Text))
                                    personaNueva.FechaNacimiento = Convert.ToDateTime(deFechaNacimiento.Text);
                                bd.Persona.Insertar(personaNueva);
                                bd.Grabar();
                                IdPersonaInsertada = personaNueva.Id;
                            }
                            else
                                IdPersonaInsertada = 0;
                            break;
                    }
                }
                //MostrarMensajes("Operación realizada con éxito");
            }
            catch (Exception ex)
            {
                IdPersonaInsertada = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en adminsitración personas: " + ex.Message);
            }
            return IdPersonaInsertada;
        }

        protected void cmbProvincia_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    cmbProvincia.DataSource = db.Provincia.ObtenerProvinciasPorDepartamento(int.Parse(e.Parameter));
                    cmbProvincia.DataBind();
                }
                //cmbProvincia.ReadOnly = false;
            }catch(Exception)
            {

            }
        }

        /// <summary>
        /// Inserta o actualiza empresas de acuerdo al parámetro Operación
        /// </summary>
        /// <param name="idpersona">0 = No se Inserta, >0 = Si se inserta persona</param>
        /// <param name="Operacion">1=Editar, 2=Insertar</param>
        /// <returns></returns>
        protected int AdministrarCliente(int idpersona, int Operacion)
        {
            try
            {

                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Cliente clienteActualizar = bd.Cliente.ObtenerPorId(int.Parse(txtId.Text));
                            clienteActualizar.IdEstado = int.Parse(cmbEstado.Value.ToString());
                            bd.Cliente.Actualizar(clienteActualizar);
                            bd.Grabar();
                            idClienteInsertado = 0;
                            MostrarMensajes("Operación realizada con éxito");
                            break;
                        case 2:
                            if (idpersona > 0)
                            {
                                var clienteInsertar = new Cliente
                                {
                                    IdPersona = idpersona,
                                    FechaCreacion = DateTime.Today,
                                    IdEstado = 15,

                                };
                                bd.Cliente.Insertar(clienteInsertar);
                                bd.Grabar();
                                idClienteInsertado = clienteInsertar.IdCliente;
                                MostrarMensajes("Operación realizada con éxito");
                            }
                            else
                            {
                                MostrarMensajes("Operación denegada: ya existe un cliente registrado con el número de dni ingresado!!");
                            }
                            break;
                    }
                }
                //MostrarMensajes("Operación realizada con éxito");
            }
            catch (Exception ex)
            {
                idClienteInsertado = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en administración clientes: " + ex.Message);
            }
            return idClienteInsertado;
        }
    }
}