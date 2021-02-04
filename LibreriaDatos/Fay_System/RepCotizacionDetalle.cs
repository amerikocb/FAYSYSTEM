using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepCotizacionDetalle:Repositorio<CotizacionDetalle>
    {
        public RepCotizacionDetalle(FayceEntities contexto) : base(contexto)
        {

        }
        public List<DTOCotizacionDetalle> ObtenerDetalleCotizacion(int IdCotizacion)
        {
            return (from c in _contexto.Cotizacion
                    join cd in _contexto.CotizacionDetalle on c.Id equals cd.IdCotizacion
                    join s in _contexto.Servicio on cd.IdServicio equals s.Id
                    join um in _contexto.UnidadMedida on cd.IdUnidadMedida equals um.Id
                    where cd.IdCotizacion == IdCotizacion && cd.IdEstado == 37
                    select new DTOCotizacionDetalle
                    {
                        Id = cd.Id,
                        ItemDescripcion = s.Descripcion,
                        IdServicio = s.Id,
                        Cantidad = cd.Cantidad,
                        Importe = (double)(cd.Cantidad * cd.Precio),
                        Precio = cd.Precio,
                        TipoMoneda = cd.TipoMoneda,
                        Equivalencia = cd.Equivalencia,
                        IdUnidadMedida = um.Id,
                        Observaciones = cd.Observaciones
                    }).OrderByDescending(rde => rde.Id).ToList();
        }
        public void InsertarValoresCotizacionDetalle(OrderedDictionary nuevosValores, int IdCotizacion, decimal precioDolar)
        {
            CotizacionDetalle cotDetalle = new CotizacionDetalle();
            cotDetalle.IdCotizacion = IdCotizacion;
            cotDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(cotDetalle, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.CotizacionDetalle.Insertar(cotDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(CotizacionDetalle item, OrderedDictionary valores)
        {
            item.IdServicio = int.Parse(valores["IdServicio"].ToString());
            item.IdEstado = 37;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
            item.IdUnidadMedida = int.Parse(valores["IdUnidadMedida"].ToString());
            //item.IdAlmacen = int.Parse(valores["IdAlmacen"].ToString());
            item.TipoMoneda = valores["TipoMoneda"].ToString();
            item.Equivalencia = decimal.Parse(valores["Equivalencia"].ToString());
            item.Observaciones = valores["Observaciones"] != null? valores["Observaciones"].ToString() : null;
        }
        public void ActualizarCotizacionDetalle(OrderedDictionary keys, OrderedDictionary nuevosValores, decimal precioDolar)
        {
            var id = Convert.ToInt32(keys["Id"]);
            CotizacionDetalle cotDetalle = _contexto.CotizacionDetalle.Where(cd => cd.Id == id).FirstOrDefault<CotizacionDetalle>();
            cotDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(cotDetalle, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarCotizacionDetalle(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            CotizacionDetalle reqDetalle = _contexto.CotizacionDetalle.Where(cd => cd.Id == id).FirstOrDefault<CotizacionDetalle>();
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

    }
}
