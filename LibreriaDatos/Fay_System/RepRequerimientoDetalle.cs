using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using System.encri

namespace LibreriaDatos.Fay_System
{
    public class RepRequerimientoDetalle : Repositorio<RequerimientoDetalle>
    {
        public RepRequerimientoDetalle(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTORequerimientoDetalle> ObtenerDetalleRequerimiento(int IdRequerimiento)
        {
            return (from r in _contexto.Requerimiento
                    join rd in _contexto.RequerimientoDetalle on r.Id equals rd.IdRequerimiento
                    join p in _contexto.Material on rd.IdMaterial equals p.Id
                    join e in _contexto.Empresa on rd.IdProveedor equals e.Id
                    join pe in _contexto.Persona on e.IdPersona equals pe.Id
                    where rd.IdRequerimiento == IdRequerimiento && rd.IdEstado == 29
                    select new DTORequerimientoDetalle
                    {
                        Id = rd.Id,
                        Material = p.Id,
                        Cantidad = rd.Cantidad,
                        Proveedor = e.Id,
                        Importe = (decimal)(rd.Cantidad * rd.Precio),
                        Precio = rd.Precio,
                        Equivalencia  = rd.Equivalencia,
                        TipoMoneda = rd.TipoMoneda,
                        IdUnidadMedida = rd.IdUnidadMedida
                    }).OrderByDescending(rde => rde.Id).ToList();
        }

        public List<MaterialReqDet> ObtenerMaterialesRequerimiento(int IdRequerimiento)
        {
            return (from r in _contexto.Requerimiento
                    join rd in _contexto.RequerimientoDetalle on r.Id equals rd.IdRequerimiento
                    join p in _contexto.Material on rd.IdMaterial equals p.Id
                    where rd.IdRequerimiento == IdRequerimiento && rd.IdEstado == 29
                    select new MaterialReqDet
                    {
                        Id = p.Id,
                        Descripcion = p.Descripcion 
                    }).OrderByDescending(rde => rde.Id).ToList();
        }
        public void InsertarValoresRequerimientoDetalle(OrderedDictionary nuevosValores, int IdRequerimiento, decimal precioDolar)
        {
            RequerimientoDetalle reqDetalle = new RequerimientoDetalle();
            reqDetalle.IdRequerimiento = IdRequerimiento;
            reqDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(reqDetalle, nuevosValores );
            using (var db = new UnidadDeTrabajo())
            {
                db.RequerimientoDetalle.Insertar(reqDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(RequerimientoDetalle item, OrderedDictionary valores)
        {
            item.IdMaterial = Convert.ToInt32(valores["Material"]);
            item.IdProveedor = Convert.ToInt32(valores["Proveedor"]);
            item.IdEstado = 29;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            item.AfectaIGV = true;
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
            item.TipoMoneda = valores["TipoMoneda"].ToString();
            item.Equivalencia = decimal.Parse(valores["Equivalencia"].ToString());
            item.IdUnidadMedida = Convert.ToInt32(valores["IdUnidadMedida"]);
            //item.PrecioDolar = precioDolar;
        }
        public void ActualizarRequerimientoDetalle(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["Id"]);
            RequerimientoDetalle reqDetalle = _contexto.RequerimientoDetalle.Where(rd => rd.Id == id).FirstOrDefault<RequerimientoDetalle>();
            LeerNuevosValores(reqDetalle, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarRequerimientoDetalle(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            RequerimientoDetalle reqDetalle = _contexto.RequerimientoDetalle.Where(rd => rd.Id == id).FirstOrDefault<RequerimientoDetalle>();
            reqDetalle.IdEstado = 30;
            _contexto.SaveChanges();
        }

        public class MaterialReqDet
        {
            public int Id { get; set; }
            public string Descripcion { get; set; }
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
