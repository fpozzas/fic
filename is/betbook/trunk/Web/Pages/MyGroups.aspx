<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
CodeBehind="MyGroups.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.MyGroups" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <p>
        <asp:Label ID="lblNoUserGroups" meta:resourcekey="lblNoUserGroups" runat="server"></asp:Label>
    </p>
    <form id="form" runat="server">
    <asp:GridView ID="gvViewGroups" runat="server" GridLines="None" AutoGenerateColumns="False"
        CssClass="cooltable">
        <Columns>
            <asp:BoundField DataField="name" meta:resourcekey="colGroupName"     />
            <asp:TemplateField meta:resourcekey="colGroupCreator">
                <ItemTemplate>
                    <asp:Label 
                    ID="lblGroupCreator" 
                    runat="server"
                    Text='<%# ((Es.Udc.DotNet.Betbook.Model.User)Eval("user")).login %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="description" meta:resourcekey="colGroupDesc" />
            <asp:HyperLinkField meta:resourcekey="btnLeaveGroup" DataNavigateUrlFields="groupId" 
                                DataNavigateUrlFormatString="~/Pages/LeaveGroup.aspx?groupId={0}" />
        </Columns>
    </asp:GridView>
    </form>
    <br />
    <br />
</asp:Content>