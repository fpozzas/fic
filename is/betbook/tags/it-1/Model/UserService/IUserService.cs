using System;
using System.Collections.Generic;
using Es.Udc.DotNet.ModelUtil.Transactions;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.CommentDao;

namespace Es.Udc.DotNet.Betbook.Model.UserService
{
    public interface IUserService
    {
        IUserDao UserDao { set; }
        ICommentDao CommentDao { set; }

        User FindUser(long userId);

        User RegisterUser(String loginName, String clearPassword, UserDetails userDetails);
        LoginResult Login(String login, String password, Boolean passwordIsEncrypted);

        void UpdateUserDetails(long userId, UserDetails userDetails);
        void ChangePassword(long userId, String oldClearPassword, String newClearPassword);

        UserDetails FindUserDetails(long userId);

    }
}
