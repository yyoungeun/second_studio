using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using DevUser.Models;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace DevUser.Repositories
{
    public class UserRepository
    {
        //공통으로 사용될 커넥션 개체
        private SqlConnection con;

        public UserRepository()
        {
            con = new SqlConnection();
            con.ConnectionString = WebConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
        }

        public void AddUser(string userId, string password)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "writeUsers";
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@UserID", userId);
            cmd.Parameters.AddWithValue("@Password", password);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public UserViewModel GetUserByUserId(string userId)
        {
            UserViewModel r = new UserViewModel();

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "Select * From Users Where UserID = @UserID";
            cmd.CommandType = CommandType.Text;

            cmd.Parameters.AddWithValue("@UserID", userId);

            con.Open();
            IDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                r.Id = dr.GetInt32(0);
                r.UserId = dr.GetString(1);
                r.Password = dr.GetString(2);
            }
            con.Close();

            return r;
        }

        public void ModifyUser(int uid, string userId, string password)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = con;
            cmd.CommandText = "ModifyUsers";
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@UserID", userId);
            cmd.Parameters.AddWithValue("@Password", password);
            cmd.Parameters.AddWithValue("@UID", uid);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();
        }

        public bool IsCorrectUser(string userId, string password)
        {
            bool result = false;
            try
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;
                cmd.CommandText = "Select * From Users Where UserID = @UserID And Password = @Password";
                cmd.CommandType = CommandType.Text;
                cmd.Parameters.AddWithValue("@UserID", userId);
                cmd.Parameters.AddWithValue("@Password", password);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    result = true; //아이디와 암호가 맞는 데이터 있음
                }

                dr.Close();
                con.Close();
                
            }
            catch(Exception ex)
            {

            }
            return result;
        }
    }
}