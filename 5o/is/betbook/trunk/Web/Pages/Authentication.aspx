<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Authentication.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.User.Authentication" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Pages/Register.aspx" meta:resourcekey="lnkRegister" />
    <div id="form">
        <form id="AuthenticationForm" method="POST" runat="server">
            <div class="field">
                <span class="label">
                    <asp:Localize ID="lclLogin" runat="server" meta:resourcekey="lclLogin" />
                </span>
                <span class="entry">
                    <asp:TextBox ID="txtLogin" runat="server" Width="100" Columns="16"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvLogin" runat="server"
                        ControlToValidate="txtLogin" Display="Dynamic" Text="<%$ Resources:Common, mandatoryField %>"/>
                    <asp:Label ID="lblLoginError" runat="server" ForeColor="Red" Style="position: relative"
                        Visible="False" meta:resourcekey="lblLoginError">                        
                    </asp:Label>
                </span>
            </div>
            <div class="field">
                <span class="label">
                    <asp:Localize ID="lclPassword" runat="server" meta:resourcekey="lclPassword" />
                </span>
                <span class="entry">
                    <asp:TextBox TextMode="Password" ID="txtPassword" runat="server" Width="100" Columns="16"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword" Display="Dynamic" Text="<%$ Resources:Common, mandatoryField %>"/>
                    <asp:Label ID="lblPasswordError" runat="server" ForeColor="Red" Style="position: relative"
                        Visible="False" meta:resourcekey="lblPasswordError">       
                    </asp:Label>
                </span>
            </div>
            <div class="checkbox">
                <asp:CheckBox ID="checkRememberPassword" runat="server" TextAlign="Left" meta:resourcekey="checkRememberPassword" />
            </div>
            <div class="button">
                <asp:Button ID="btnLogin" runat="server" OnClick="btnLogin_Click" meta:resourcekey="btnLogin" />
            </div>
        </form>
    </div>
</asp:Content>
