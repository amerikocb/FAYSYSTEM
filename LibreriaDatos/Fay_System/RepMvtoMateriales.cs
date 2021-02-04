using LibreriaDatos.Fay_System.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepMvtoMateriales:Repositorio<StockTransaccion>
    {
        public RepMvtoMateriales(FayceEntities contexto) : base(contexto)
        {
        }

        public List<DTOMvtoMateriales> ObtenerMovimientoMateriales()
        {
            return (from mm in _contexto.StockTransaccion
                    join p in _contexto.Material on mm.IdMaterial equals p.Id
                    join a in _contexto.Almacen on mm.IdAlmacen equals a.Id
                    join u in _contexto.Usuario on mm.IdUsuario equals u.id
                    select new DTOMvtoMateriales
                    {
                        IdTransaccion=mm.IdTransaccion,
                        FechaTransaccion = mm.FechaTransaccion,
                        Accion = mm.Accion,
                        Operacion = mm.Operacion,
                        StockFecha = mm.StockFecha,
                        CantidadAlterada = mm.CantidadAlterada,
                        StockResultante = mm.StockResultante,
                        IdAlmacen = a.Id,
                        IdMaterial = p.Id,
                        Usuarioo = u.Nombre,
                    }).OrderByDescending(st=> st.IdTransaccion). ToList();
        }
    }
}
