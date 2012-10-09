<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.Register" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">

    <span>
        <asp:Label ID="lblLoginError" runat="server" ForeColor="Red" Style="position: relative"
                   Visible="False" meta:resourcekey="lblLoginError"></asp:Label>
    </span>                            
                            
    <div id="form">
        <form id="RegisterForm" method="post" runat="server">
        <div class="field">
            <span class="entry">
                <asp:TextBox ID="txtLogin" runat="server" 
                    Width="200px" Columns="16"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLogin" runat="server" ControlToValidate="txtLogin"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
            <span class="label">
                <asp:Localize ID="lblLogin" meta:resourcekey="lblLogin" runat="server"></asp:Localize>
            </span>
        </div>
        <div class="field">
            <span class="entry">
                <asp:TextBox ID="txtPassword" runat="server" Width="200px" Columns="16" 
                    TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
            <span class="label">
                <asp:Localize ID="lblPassword" meta:resourcekey="lblPassword" runat="server"></asp:Localize>
            </span>
        </div>
        <div class="field">
            <span class="entry">
                <asp:TextBox ID="txtName" runat="server" Width="200px" Columns="16"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
            <span class="label">
                <asp:Localize ID="lblName" meta:resourcekey="lblName" runat="server"></asp:Localize>
            </span>
        </div>
        <div class="field">
            <span class="entry">
                <asp:TextBox ID="txtSurname" runat="server" Width="200px" Columns="16"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvSurname" runat="server" ControlToValidate="txtSurname"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>" 
                CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
            <span class="label">
                <asp:Localize ID="lblSurname" meta:resourcekey="lblSurname" runat="server"></asp:Localize>
            </span>
        </div>
        <div class="field">
            <span class="entry">
                <asp:TextBox ID="txtEmail" runat="server" Width="200px" Columns="16"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>"
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    meta:resourcekey="revEmail"></asp:RegularExpressionValidator>
            </span>
            <span class="label">
                <asp:Localize ID="lblEmail" meta:resourcekey="lblEmail" runat="server"></asp:Localize>
            </span>
        </div>
        
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclLanguage" runat="server" meta:resourcekey="lclLanguage" />
            </span>
            <span class="entry">
                <asp:DropDownList ID="comboLanguage" runat="server" AutoPostBack="True"
                    Width="100px" meta:resourcekey="comboLanguageResource1"></asp:DropDownList>
            </span>
        </div>
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclCountry" runat="server" meta:resourcekey="lclCountry" />
            </span>
            <span class="entry">
                <asp:DropDownList ID="comboCountry" runat="server" Width="100px"
                    meta:resourcekey="comboCountryResource1"></asp:DropDownList>
            </span>
        </div>
        
        <div class="button">
            <asp:Button ID="btnCreate" runat="server" meta:resourcekey="btnCreate" OnClick="btnCreate_Click" />
        </div>
        </form>
    </div>
    <br />
    <br />
</asp:Content>
