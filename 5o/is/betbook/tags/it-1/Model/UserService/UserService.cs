using System;
using System.Collections.Generic;
using Microsoft.Practices.Unity;
using Es.Udc.DotNet.ModelUtil.Exceptions;
using Es.Udc.DotNet.ModelUtil.Transactions;
using Es.Udc.DotNet.Betbook.Model.UserDao;
using Es.Udc.DotNet.Betbook.Model.CommentDao;
using Es.Udc.DotNet.Betbook.Model.UserService.Util;
using Es.Udc.DotNet.Betbook.Model.UserService.Exceptions;


namespace Es.Udc.DotNet.Betbook.Model.UserService
{
    class UserService: IUserService
    {
        [Dependency]
        public IUserDao UserDao { private get; set; }
        [Dependency]
        public ICommentDao CommentDao { private get; set; }

        public Es.Udc.DotNet.Betbook.Model.CommentDao.ICommentDao ICommentDao
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }

        public Es.Udc.DotNet.Betbook.Model.UserDao.IUserDao IUserDao
        {
            get
            {
                throw new System.NotImplementedException();
            }
            set
            {
            }
        }


        #region IUserService Members

        /// <exception cref="InstanceNotFoundException"/>
        public User FindUser(long userId)
        {
            return UserDao.Find(userId);
        }

        /// <exception cref="DuplicateInstanceException"/>
        [Transactional]
        public User RegisterUser(string login, string clearPassword,
            UserDetails userDetails)
        {

            try
            {
                UserDao.FindByLoginName(login);

                throw new DuplicateInstanceException(login,
                    typeof(User).FullName);

            }
            catch (InstanceNotFoundException)
            {
                String encryptedPassword = PasswordEncrypter.Crypt(clearPassword);

                User user = User.CreateUser(0, login, encryptedPassword,
                    userDetails.name);
                user.surname = userDetails.surname;
                user.email = userDetails.email;
                //user.Country = userDetails.country;
                //user.Language = userDetails.language;

                UserDao.Create(user);

                return user;

            }

        }

        /// <exception cref="InstanceNotFoundException"/>
        /// <exception cref="IncorrectPasswordException"/>
        public LoginResult Login(string login, string password, bool passwordIsEncrypted)
        {
            User user =
                UserDao.FindByLoginName(login);
            String storedPassword = user.encPassword;

            if (passwordIsEncrypted)
            {
                if (!password.Equals(storedPassword))
                {
                    throw new IncorrectPasswordException(login);
                }
            }
            else
            {
                if (!PasswordEncrypter.IsClearPasswordCorrect(password,
                        storedPassword))
                {
                    throw new IncorrectPasswordException(login);
                }
            }

            return new LoginResult(user.userId, user.name,
                storedPassword, user.languageCode, user.countryCode);
        }

        /// <exception cref="InstanceNotFoundException"/>
        [Transactional]
        public void UpdateUserDetails(long userId, UserDetails newUser)
        {
            try
            {
                User user = UserDao.Find(userId);
                if (newUser.name != null)
                    user.name = newUser.name;
                if (newUser.surname != null)
                    user.surname = newUser.surname;
                if (newUser.email != null)
                    user.email = newUser.email;
                if (newUser.countryCode != null)
                    user.countryCode = newUser.countryCode;
                if (newUser.languageCode != null)
                    user.languageCode = newUser.languageCode;
                UserDao.Update(user);
            }
            catch (InstanceNotFoundException)
            {
                throw;
            }
        }

        public UserDetails FindUserDetails(long userProfileId)
        {
            UserDetails userDetails;

            try
            {
                User user = UserDao.Find(userProfileId);

                userDetails =
                    new UserDetails(user.name,
                        user.surname, user.email,
                        user.languageCode, user.countryCode);
            }
            catch (InstanceNotFoundException e)
            {
                throw e;
            }

            return userDetails;
        }

        [Transactional]
        public void ChangePassword(long userProfileId, string oldClearPassword,
            string newClearPassword)
        {
            User user;

            try
            {
                user = UserDao.Find(userProfileId);
                String storedPassword = user.encPassword;

                if (!PasswordEncrypter.IsClearPasswordCorrect(oldClearPassword,
                    storedPassword))
                {
                    throw new IncorrectPasswordException(user.name);
                }

                user.encPassword =
                    PasswordEncrypter.Crypt(newClearPassword);

                UserDao.Update(user);
            }
            catch (InstanceNotFoundException e)
            {
                // This exception should never happen
                throw new ExecutionEngineException(e.Message);
            }

        }

        #endregion
    }
} // namespace
