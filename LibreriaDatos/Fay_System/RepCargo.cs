﻿using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepCargo:Repositorio<Cargo>
    {
        public RepCargo(FayceEntities contexto) : base(contexto)
        {
        }

    }
}
