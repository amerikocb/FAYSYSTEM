using LibreriaDatos.Fay_System.DTO;
using System.Collections.Generic;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepMaterial : Repositorio<Material>
    {
        public RepMaterial(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOMaterial> ObtenerMateriales()
        {
            return (from m in _contexto.Material
                    join s in _contexto.Stock on m.Id equals s.IdMaterial
                    join a in _contexto.Almacen on s.IdAlmacen equals a.Id
                    join e in _contexto.Estado on m.IdEstado equals e.Id
                    join u in _contexto.Usuario on m.IdUsuario equals u.id
                    select new DTOMaterial
                    {
                        IdMaterial = m.Id,
                        Codigo = m.Codigo,
                        Descripcion = m.Descripcion,
                        Estado = e.Descripcion,
                        Fecha = m.FechaCreacion,
                        IdAlmacen = a.Id,
                        Usuario = u.Nombre,
                        UnitsStock = s.Stock1,
                        IdEstado = e.Id
                    }).OrderByDescending(m => m.IdMaterial).ToList();
        }
        public DTOMaterial Obtener_DTOMaterial_x_idMaterial(int IdMaterial)
        {
            return (from m in _contexto.Material
                    join e in _contexto.Estado on m.IdEstado equals e.Id
                    where m.Id == IdMaterial
                    select new DTOMaterial
                    {
                        IdMaterial = m.Id,
                        IdEstado = m.IdEstado,
                        Codigo = m.Codigo,
                        Descripcion = m.Descripcion,
                        Costo = m.Costo,
                        Precio = m.Precio,
                    }).FirstOrDefault();
        }
        public List<DTOMaterial> Obtener_DTOMaterial_x_idAlmacen(int IdAlmacen)
        {
            return (from m in _contexto.Material
                    join s in _contexto.Stock on m.Id equals s.IdMaterial
                    join a in _contexto.Almacen on s.IdAlmacen equals a.Id
                    where a.Id == IdAlmacen
                    select new DTOMaterial
                    {
                        IdMaterial = m.Id,
                        Descripcion = m.Descripcion,
                        UnitsStock = s.Stock1,
                    }).ToList();
        }

        public string ObtenerPrecioMaterial(int IdMaterial, int IdAlmacen)
        {
            Material m = _contexto.Material.Where(ma => ma.Id == IdMaterial).FirstOrDefault();
            Stock s = _contexto.Stock.Where(st => st.IdMaterial == IdMaterial && st.IdAlmacen == IdAlmacen).FirstOrDefault();
            if (s == null)
                return m.Precio + "|0";
            else
                return m.Precio + "|" + s.Stock1;

        }

        public string ObtenerPrecioMaterial_X_Requerimiento(int IdMaterial, int IdAlmacen)
        {
            Material m = _contexto.Material.Where(ma => ma.Id == IdMaterial).FirstOrDefault();
            Stock s = _contexto.Stock.Where(st => st.IdMaterial == IdMaterial && st.IdAlmacen == IdAlmacen).FirstOrDefault();
            if (s == null)
                return m.Costo + "|0";
            else
                return m.Costo + "|" + s.Stock1;
        }

        public double ObtenerStockMaterial(int IdMaterial, int IdAlmacen)
        {
            Stock s = _contexto.Stock.Where(st => st.IdMaterial == IdMaterial && st.IdAlmacen == IdAlmacen).FirstOrDefault();
            return s.Stock1;
        }

        public List<DTOMaterial> ObtenerMaterial_x_Id(int Id)
        {
            return (from m in _contexto.Material
                    where m.Id == Id
                    select new DTOMaterial
                    {
                        IdMaterial = m.Id,
                        Descripcion = m.Descripcion
                    }).ToList();
        }
    }
}
