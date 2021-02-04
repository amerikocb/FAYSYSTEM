using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LibreriaDatos.DTO;

namespace LibreriaDatos.Fay_System
{
    public class RepAjusteInventario:Repositorio<AjusteInventario>
    {
        public RepAjusteInventario(FayceEntities contexto) : base(contexto)
        {

        }
        public AjusteInventario ajusteInventario_leer(int idAj)
        {
            return _contexto.AjusteInventario.Find(idAj);
        }
        
        public List<DTOAjusteInventario> ObtenerListaAjustesInventario()
        {
            return (from ai in _contexto.AjusteInventario
                    join e in _contexto.Estado on ai.IdEstado equals e.Id
                    join u in _contexto.Usuario on ai.idUsuario equals u.id
                    join a in _contexto.Almacen on ai.idAlmacen equals a.Id
                    select new DTOAjusteInventario
                    {
                        Id = ai.id,
                        Almacen = a.Descripcion,
                        Fecha = ai.Fecha,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion
                    }).ToList();
        }
        public int? ObtenerEstadoOrdenVenta(int IdOrdenVenta)
        {
            return (from r in _contexto.Cotizacion
                    where r.Id == IdOrdenVenta
                    select r.IdEstado).FirstOrDefault();
        }
    }
}
