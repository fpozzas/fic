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

        /// <exception cref="InstanceNotFoundException"/>
        User FindUser(long userId);

        /// <exception cref="DuplicateInstanceException"/>
        User RegisterUser(String loginName, String clearPassword, UserDetails userDetails);

        /// <exception cref="InstanceNotFoundException">User by login</exception>
        /// <exception cref="IncorrectPasswordException"/>
        LoginResult Login(String login, String password, Boolean passwordIsEncrypted);


        /// <exception cref="InstanceNotFoundException">For userId</exception>
        void UpdateUserDetails(long userId, UserDetails userDetails);

        /// <exception cref="ExecutionEngineException">When userId does not exist</exception>
        void ChangePassword(long userId, String oldClearPassword, String newClearPassword);

        /// <exception cref="InstanceNotFoundException"/>
        UserDetails FindUserDetails(long userId);

    }
}
