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
    public class RepTransferenciaStock:Repositorio<TransferenciaStock>
    {
        public RepTransferenciaStock(FayceEntities contexto) : base(contexto)
        {

        }
        public TransferenciaStock transferenciaStock_leer(int idTrans)
        {
            return _contexto.TransferenciaStock.Find(idTrans);
        }
        
        public List<TransferenciaStockDTO> ObtenerListaTransferencias()
        {
            return (from ts in _contexto.TransferenciaStock
                    join u in _contexto.Usuario on ts.IdUsuario equals u.id
                    select new TransferenciaStockDTO
                    {
                        Id = ts.Id,
                        AlmacenOrigen = ts.Almacen.Descripcion,
                        AlmacenDestino = ts.Almacen1.Descripcion,
                        Fecha = ts.Fecha,
                        Usuario = u.Nombre
                    }).OrderByDescending(t => t.Id).ToList();
        }
        public int? ObtenerEstadoOrdenVenta(int IdOrdenVenta)
        {
            return (from r in _contexto.Cotizacion
                    where r.Id == IdOrdenVenta
                    select r.IdEstado).FirstOrDefault();
        }
    }
}
