using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DevADONET.Models
{
    /// <summary>
    /// Memos테이블과 일대일 매핑되는 Memo클래스
    /// </summary>
    public class Memo
    {
        public int Num { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Title { get; set; }
        public DateTime PostDate { get; set; }
        public string PostIp { get; set; }
    }
}