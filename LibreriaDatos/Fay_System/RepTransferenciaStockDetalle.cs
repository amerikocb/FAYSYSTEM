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
    public class RepTransferenciaStockDetalle:Repositorio<TransferenciaStockDetalle>
    {
        public RepTransferenciaStockDetalle(FayceEntities contexto) : base(contexto)
        {

        }
        
        public List<TransferenciaStockDetalleDTO> ObtenerListaTransferenciaDetalle_x_IdTransf(int IdT)
        {
            return (from tsd in _contexto.TransferenciaStockDetalle
                    join m in _contexto.Material on tsd.IdMaterial equals m.Id
                    where tsd.IdTransferenciaStock == IdT
                    select new TransferenciaStockDetalleDTO
                    {
                        Id = tsd.Id,
                        Material = m.Descripcion,
                        Cantidad = tsd.Cantidad,
                        FechaCreacion = tsd.FechaCreacion
                    }).ToList();
        }
    }
}
