using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepSalidaMaterialesDetalle:Repositorio<SalidaMaterialesDetalle>
    {
        public RepSalidaMaterialesDetalle(FayceEntities contexto) : base(contexto)
        {

        }
        public List<DTOSalidaMaterialesDetalle> ObtenerDetalleSalidaMateriales(int IdSalidaMaterial)
        {
            return (from c in _contexto.SalidaMaterial
                    join cd in _contexto.SalidaMaterialesDetalle on c.Id equals cd.IdSalidaMaterial
                    join s in _contexto.Material on cd.IdMaterial equals s.Id
                    join a in _contexto.Almacen on cd.IdAlmacen equals a.Id
                    where cd.IdSalidaMaterial == IdSalidaMaterial && cd.IdEstado == 62
                    select new DTOSalidaMaterialesDetalle
                    {
                        Id = cd.Id,
                        IdAlmacen = a.Id,
                        ItemDescripcion = s.Descripcion,
                        IdMaterial = s.Id,
                        Cantidad = cd.Cantidad,
                        Importe = (double)(cd.Cantidad * cd.Precio),
                        Precio = cd.Precio,
                        TipoMoneda = cd.TipoMoneda,
                        Equivalencia = cd.Equivalencia,
                        Stock = 0,
                        IdUnidadMedida = cd.IdUnidadMedida
                    }).OrderByDescending(rde => rde.Id).ToList();
        }
        public void InsertarValoresSalidaMaterialDetalle(OrderedDictionary nuevosValores, int IdSalidaMaterial, decimal precioDolar)
        {
            SalidaMaterialesDetalle cotDetalle = new SalidaMaterialesDetalle();
            cotDetalle.IdSalidaMaterial = IdSalidaMaterial;
            cotDetalle.PrecioDolar = precioDolar;
            cotDetalle.IdEstado = 62;
            LeerNuevosValores(cotDetalle, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.SalidaMaterialesDetalle.Insertar(cotDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(SalidaMaterialesDetalle item, OrderedDictionary valores)
        {
            item.IdMaterial = int.Parse(valores["IdMaterial"].ToString());
            //item.IdEstado = 37;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
            item.IdAlmacen = int.Parse(valores["IdAlmacen"].ToString());
            item.IdUnidadMedida = int.Parse(valores["IdUnidadMedida"].ToString());
            //item.TipoMoneda = valores["TipoMoneda"].ToString();
            //item.Equivalencia = decimal.Parse(valores["Equivalencia"].ToString());
        }
        public void ActualizarSalidaMaterialesDetalle(OrderedDictionary keys, OrderedDictionary nuevosValores, decimal precioDolar)
        {
            var id = Convert.ToInt32(keys["Id"]);
            SalidaMaterialesDetalle cotDetalle = _contexto.SalidaMaterialesDetalle.Where(cd => cd.Id == id).FirstOrDefault<SalidaMaterialesDetalle>();
            cotDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(cotDetalle, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarSalidaMaterialDetalle(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            SalidaMaterialesDetalle reqDetalle = _contexto.SalidaMaterialesDetalle.Where(cd => cd.Id == id).FirstOrDefault<SalidaMaterialesDetalle>();
            reqDetalle.IdEstado = 63;
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
