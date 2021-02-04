using LibreriaDatos.DTO;
using LibreriaDatos.Fay_System.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepAjusteInventarioDetalle : Repositorio<AjusteInventarioDetalle>
    {
        public RepAjusteInventarioDetalle(FayceEntities contexto) : base(contexto)
        {

        }
        public List<AjusteInventarioDetalleDTO> AjusteInventarioDetalle_listarDTO(int IdAjusteInventario)
        {
            return (from det in _contexto.AjusteInventarioDetalle
                    join m in _contexto.Material on det.IdMaterial equals m.Id
                    where det.idAjusteInventario == IdAjusteInventario
                    select new AjusteInventarioDetalleDTO
                    {
                        Id = det.id,
                        IdMaterial = det.IdMaterial,
                        Material = m.Descripcion,
                        Cantidad = det.Cantidad
                    }).OrderByDescending(ai => ai.Id).ToList();
        }
        public void InsertarValoresOrdenVentaDetalle(OrderedDictionary nuevosValores, int IdOrdenVenta)
        {
            OrdenVentaDetalle cotDetalle = new OrdenVentaDetalle();
            cotDetalle.IdOrdenVenta = IdOrdenVenta;
            LeerNuevosValores(cotDetalle, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.OrdenVentaDetalle.Insertar(cotDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(OrdenVentaDetalle item, OrderedDictionary valores)
        {
            item.IdServicio = int.Parse(valores["ItemDescripcion"].ToString());
            item.IdEstado = 37;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            //item.AfectaIGV = true;
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
        }
        public void ActualizarOrdenVentaDetalle(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["Id"]);
            OrdenVentaDetalle cotDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            LeerNuevosValores(cotDetalle, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarOrdenVentaDetalle(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            OrdenVentaDetalle reqDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            reqDetalle.IdEstado = 38;
            _contexto.SaveChanges();
        }
        public List<int> ObtenerProveedoresPorRequerimiento(int IdRequerimiento)
        {
            return (from rd in _contexto.RequerimientoDetalle
                    where rd.IdRequerimiento == IdRequerimiento
                    select rd.IdProveedor).Distinct().ToList();
            //_contexto.RequerimientoDetalle.Where(rd => rd.IdRequerimiento == IdRequerimiento).ToList();
        }
        public int ContarDetalleOrdenVentaMayorStock(int IdOrdenVenta)
        {
            //return (from ovd in _contexto.OrdenVentaDetalle
            //        join st in _contexto.Stock on ovd.IdMaterial equals st.IdMaterial
            //        where ovd.IdOrdenVenta == IdOrdenVenta && ovd.Cantidad > st.Stock1
            //        select ovd.Id).Count();
            return 0;
        }
    }
}
