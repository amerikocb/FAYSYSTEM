using LibreriaDatos;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Data.Entity.Validation;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class UnidadDeTrabajo : IDisposable
    {
        private FayceEntities _contexto = new FayceEntities();

        private RepUsuario _usuario;
        private RepRequerimiento _requerimiento;
        private RepRequerimientoDetalle _requerimientoDetalle;
        private RepOrdenCompra _ordenCompra;
        private RepOrdenCompraDetalle _ordenCompraDetalle;
        private RepRecepcion _recepcion;
        private RepRecepcionDetalle _recepcionDetalle;
        private RepEmpresa _empresa;
        private RepTipoDocumento _tipoDocumento;
        private RepMenu _menu;
        private RepMaterial _material;
        private RepPersona _persona;
        private RepEmpleado _empleado;
        private RepEstado _estado;
        private RepCargo _cargo;
        private RepCotizacion _cotizacion;
        private RepCotizacionDetalle _cotizacionDetalle;
        private RepOrdenVenta _ordenVenta;
        private RepOrdenVentaDetalle _ordenVentaDetalle;
        private RepOrdenTrabajo _ordenTrabajo;
        private RepOperadorOrdenTrabajo _operadorOrdenTrabajo;
        private RepTipoProfesion _tipoprofesion;
        private RepServicios _servicio;
        private RepCliente _cliente;
        private RepMvtoMateriales _mvtoMateriales;
        private RepStock _stock;
        private RepTipoUsuario _tipoUsuario;
        private RepDepartamento _departamento;
        private RepProvincia _provincia;
        private RepAlmacen _almacen;
        private RepMenuPerfil _menuPerfil;
        private RepAjusteInventarioDetalle _ajusteInventarioDetalle;
        private RepAjusteInventario _ajusteInventario;
        private RepBodegaInventarioCorte _bodegaInventarioCorte;
        private RepPrensaOrdenTrabajo _prensaOrdenTrabajo;
        private RepPosPrensaOrdenTrabajo _posPrensaOrdenTrabajo;
        private RepSalidaMaterial _salidaMaterial;
        private RepSalidaMaterialesDetalle _salidaMaterialesDetalle;
        private RepComprobanteVenta _comprobanteVenta;
        private RepComprobanteVentaDetalle _comprobanteVentaDetalle;
        private RepUnidadMedida _unidadMedida;
        private RepAutocorriativoOT _autocorriativoOT;
        private RepMarcaMaterial _marcaMaterial;
        private RepTransferenciaStock _transferenciaStock;
        private RepTransferenciaStockDetalle _transferenciaStockDetalle;
        private RepEgreso _egreso;
        private RepAdelantosOrdenVenta _adelanto;

        //private RepositorioArea> _area; // <= NO BORRAR SOLO DE MUESTRA.

        //tablas con metodos genericos y metodos especificos:
        public RepMenu Menu
        {
            get { return this._menu ?? new LibreriaDatos.Fay_System.RepMenu(_contexto); }
        }
        public RepMenuPerfil MenuPerfil
        {
            get { return this._menuPerfil ?? new LibreriaDatos.Fay_System.RepMenuPerfil(_contexto); }
        }
        public RepPersona Persona
        {
            get { return this._persona ?? new RepPersona(_contexto); }
        }
        public RepAutocorriativoOT AutoCorriativoOrdenTrabajo
        {
            get { return this._autocorriativoOT ?? new RepAutocorriativoOT(_contexto); }
        }
        public RepEmpleado Empleado
        {
            get { return this._empleado ?? new RepEmpleado(_contexto); }
        }
        public RepDepartamento Departamento
        {
            get { return this._departamento ?? new RepDepartamento(_contexto); }
        }
        public RepProvincia Provincia
        {
            get { return this._provincia ?? new RepProvincia(_contexto); }
        }
        public RepEgreso Egresos
        {
            get { return this._egreso ?? new RepEgreso(_contexto); }
        }
        public RepAdelantosOrdenVenta AdelantosOrdenVenta
        {
            get { return this._adelanto ?? new RepAdelantosOrdenVenta(_contexto); }
        }
        public RepCliente Cliente
        {
            get { return this._cliente ?? new RepCliente(_contexto); }
        }
        public RepEstado Estado
        {
            get { return this._estado ?? new RepEstado(_contexto); }
        }
        public RepTipoUsuario TipoUsuario
        {
            get { return this._tipoUsuario ?? new RepTipoUsuario(_contexto); }
        }
        public RepUsuario Usuario
        {
            get { return this._usuario ?? new RepUsuario(_contexto); }
        }
        public RepRequerimiento Requerimiento 
        {
            get { return this._requerimiento ?? new RepRequerimiento(_contexto); }
        }
        public RepCargo Cargo
        {
            get { return this._cargo ?? new RepCargo(_contexto); }
        }
        public RepCotizacion Cotizacion
        {
            get { return this._cotizacion ?? new RepCotizacion(_contexto); }
        }
        public RepCotizacionDetalle CotizacionDetalle
        {
            get { return this._cotizacionDetalle ?? new RepCotizacionDetalle(_contexto); }
        }
        public RepSalidaMaterial SalidaMaterial
        {
            get { return this._salidaMaterial ?? new RepSalidaMaterial(_contexto); }
        }
        public RepSalidaMaterialesDetalle SalidaMaterialesDetalle
        {
            get { return this._salidaMaterialesDetalle ?? new RepSalidaMaterialesDetalle(_contexto); }
        }
        public RepOrdenVenta OrdenVenta
        {
            get { return this._ordenVenta ?? new RepOrdenVenta(_contexto); }
        }
        public RepComprobanteVenta ComprobanteVenta
        {
            get { return this._comprobanteVenta ?? new RepComprobanteVenta(_contexto); }
        }
        public RepComprobanteVentaDetalle ComprobanteVentaDetalle
        {
            get { return this._comprobanteVentaDetalle ?? new RepComprobanteVentaDetalle(_contexto); }
        }
        public RepOrdenVentaDetalle OrdenVentaDetalle
        {
            get { return this._ordenVentaDetalle ?? new RepOrdenVentaDetalle(_contexto); }
        }
        public RepAjusteInventario AjusteInventario
        {
            get { return this._ajusteInventario ?? new RepAjusteInventario(_contexto); }
        }
        public RepTransferenciaStock TransferenciaStock
        {
            get { return this._transferenciaStock ?? new RepTransferenciaStock(_contexto); }
        }
        public RepTransferenciaStockDetalle TransferenciaStockDetalle
        {
            get { return this._transferenciaStockDetalle ?? new RepTransferenciaStockDetalle(_contexto); }
        }
        public RepAjusteInventarioDetalle AjusteInventarioDetalle
        {
            get { return this._ajusteInventarioDetalle ?? new RepAjusteInventarioDetalle(_contexto); }
        }
        public RepOrdenTrabajo OrdenTrabajo
        {
            get { return this._ordenTrabajo ?? new RepOrdenTrabajo(_contexto); }
        }
        public RepBodegaInventarioCorte BodegaInventarioCorte
        {
            get { return this._bodegaInventarioCorte ?? new RepBodegaInventarioCorte(_contexto); }
        }
        public RepPrensaOrdenTrabajo PrensaOrdenTrabajo
        {
            get { return this._prensaOrdenTrabajo ?? new RepPrensaOrdenTrabajo(_contexto); }
        }
        public RepPosPrensaOrdenTrabajo PosPrensaOrdenTrabajo
        {
            get { return this._posPrensaOrdenTrabajo ?? new RepPosPrensaOrdenTrabajo(_contexto); }
        }
        public RepMaterial Material
        {
            get { return this._material ?? new RepMaterial(_contexto); }
        }
        public RepAlmacen Almacen
        {
            get { return this._almacen ?? new RepAlmacen(_contexto); }
        }
        public RepStock Stock
        {
            get { return this._stock ?? new RepStock(_contexto); }
        }
        public RepMvtoMateriales MvtoMateriales 
        {
            get { return this._mvtoMateriales ?? new RepMvtoMateriales(_contexto); }
        }
        public RepTipoProfesion TipoProfesion
        {
            get { return this._tipoprofesion ?? new RepTipoProfesion(_contexto); }
        }
        public RepServicios Servicio
        {
            get { return this._servicio ?? new RepServicios(_contexto); }
        }
        public RepRequerimientoDetalle RequerimientoDetalle
        {
            get { return this._requerimientoDetalle ?? new RepRequerimientoDetalle(_contexto); }
        }
        private Boolean disposed = false;
        public RepOrdenCompra OrdenCompra
        {
            get { return this._ordenCompra ?? new RepOrdenCompra(_contexto); }
        }
        public RepOrdenCompraDetalle OrdenCompraDetalle
        {
            get { return this._ordenCompraDetalle ?? new RepOrdenCompraDetalle(_contexto); }
        }
        public RepRecepcion Recepcion
        {
            get { return this._recepcion ?? new RepRecepcion(_contexto); }
        }
        public RepRecepcionDetalle RecepcionDetalle
        {
            get { return this._recepcionDetalle ?? new RepRecepcionDetalle(_contexto); }
        }
        public RepEmpresa Empresa
        {
            get { return this._empresa ?? new RepEmpresa(_contexto); }
        }
        public RepTipoDocumento TipoDocumento
        {
            get { return this._tipoDocumento ?? new RepTipoDocumento(_contexto); }
        }
        public RepUnidadMedida UnidadMedida
        {
            get { return this._unidadMedida ?? new RepUnidadMedida(_contexto); }
        }
        public RepMarcaMaterial MarcaMaterial
        {
            get { return this._marcaMaterial ?? new RepMarcaMaterial(_contexto); }
        }
        protected virtual void Dispose(Boolean disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _contexto.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public int Grabar()
        {
            try
            {
                return _contexto.SaveChanges();
            }
            catch(DbEntityValidationException ex)
            {
                StringBuilder errores = new StringBuilder();
                foreach(DbEntityValidationResult item in ex.EntityValidationErrors)
                {
                    DbEntityEntry entry = item.Entry;
                    string entityTypeName = entry.Entity.GetType().Name;
                    foreach(DbValidationError subItem in item.ValidationErrors)
                    {
                        string msg = string.Format("Error ocurrido en {0} de {1} mensaje: '{2}'. ",
                            entityTypeName, subItem.PropertyName, subItem.ErrorMessage);
                        errores.AppendLine(msg);
                    }
                    switch (entry.State)
                    {
                        case EntityState.Added:
                            entry.State = EntityState.Detached;
                            break;
                        case EntityState.Modified:
                            entry.State = EntityState.Modified;
                            break;
                        case EntityState.Deleted:
                            entry.State = EntityState.Deleted;
                            break;
                    }
                }
                throw new Exception(errores.ToString());
            }
        }
        public int actualizarTipoCambio(double DolarCompra, double DolarVenta)
        {
            Configuracion conf = _contexto.Configuracion.Where(cnf => cnf.IdConfiguracion == 1).FirstOrDefault();
            conf.DolarCompra = DolarCompra;
            conf.DolarVenta = DolarVenta;
            Grabar();
            return 0;
        }

        public double ObenerPrecioDolar()
        {
            Configuracion conf = _contexto.Configuracion.Where(cnf => cnf.IdConfiguracion == 1).FirstOrDefault();
            return conf.DolarVenta;
        }

        public bool? ComprobarSoloLectura(int IdUsuario, int IdFormulario)
        {
            MenuPerfil mp = _contexto.MenuPerfil.Where(m => m.IdEstado == 53 && m.IdUsuario == IdUsuario && m.IdMenuHijo == IdFormulario).FirstOrDefault();
            return mp.SoloLectura;
        }
    }
}