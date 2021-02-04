using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
   public  class RepStock:Repositorio<Stock>
    {
        public RepStock(FayceEntities contexto) : base(contexto)
        {
        }
        public double ObtenerStock_MaterialAlmacen(int IdMaterial, int IdAlmacen)
        {
            return (from s in _contexto.Stock
                    where s.IdAlmacen == IdAlmacen && s.IdMaterial == IdMaterial
                    select s.Stock1).FirstOrDefault();
        }
        public Stock Stock_leer(int idMaterial, int idAlmacen)
        {
            return _contexto.Stock.Where(c => c.IdMaterial == idMaterial && c.IdAlmacen == idAlmacen).FirstOrDefault();
        }

        public Stock Stock_leer_x_Id(int idStock)
        {
            return _contexto.Stock.Where(s => s.Id == idStock).FirstOrDefault();
        }

        public int Stock_leerId(int idMaterial, int idAlmacen)
        {
            var st = _contexto.Stock.Where(c => c.IdMaterial == idMaterial && c.IdAlmacen == idAlmacen).FirstOrDefault();
            return st.Id;
        }

    }
}
